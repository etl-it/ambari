/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
define([
      'angular',
      'lodash',
      'jquery',
      './directives',
      './queryCtrl'
    ],
    function (angular, _) {
      'use strict';

      var module = angular.module('grafana.services');

      module.factory('AmbariMetricsDatasource', function ($q, backendSrv, templateSrv) {
        /**
         * AMS Datasource Constructor
         */
        function AmbariMetricsDatasource(datasource) {
          this.name = datasource.name;
          this.url = datasource.url;
          this.initMetricAppidMapping();
        }
        var allMetrics = [];
        var appIds = [];
        AmbariMetricsDatasource.prototype.initMetricAppidMapping = function () {
          backendSrv.get(this.url + '/ws/v1/timeline/metrics/metadata')
            .then(function (items) {
              allMetrics = [];
              appIds = [];
              //We remove a couple of components from the list that do not contain any
              //pertinent metrics.
              delete items.timeline_metric_store_watcher; delete items.amssmoketestfake;
              for (var key in items) {
                if (items.hasOwnProperty(key)) {
                  items[key].forEach(function (_item) {
                    allMetrics.push({
                      metric: _item.metricname,
                      app: key
                    });
                  });
                }
                appIds = _.keys(items);
              }
            });
        };

        /**
         * AMS Datasource  Authentication
         */
        AmbariMetricsDatasource.prototype.doAmbariRequest = function (options) {
          if (this.basicAuth || this.withCredentials) {
            options.withCredentials = true;
          }
          if (this.basicAuth) {
            options.headers = options.headers || {};
            options.headers.Authorization = this.basicAuth;
          }

          options.url = this.url + options.url;
          options.inspect = {type: 'discovery'};

          return backendSrv.datasourceRequest(options);
        };

        /**
         * AMS Datasource  Query
         */
        AmbariMetricsDatasource.prototype.query = function (options) {
          var emptyData = function (metric) {
            return {
              data: {
                target: metric,
                datapoints: []
              }
            };
          };
          var self = this;
          var getMetricsData = function (target) {
            return function (res) {
              console.log('processing metric ' + target.metric);
              if (!res.metrics[0] || target.hide) {
                return $q.when(emptyData(target.metric));
              }
              var series = [];
              var metricData = res.metrics[0].metrics;
              var hostLegend = res.metrics[0].hostname ? ' on ' + res.metrics[0].hostname : '';
              var timeSeries = {};
              if (target.hosts === undefined || target.hosts.trim() === "") {
                timeSeries = {
                  target: target.metric + hostLegend,
                  datapoints: []
                };
              } else {
                timeSeries = {
                  target: target.metric + ' on ' + target.hosts,
                  datapoints: []
                };
              }
              for (var k in metricData){
                if (metricData.hasOwnProperty(k)) {
                  timeSeries.datapoints.push([metricData[k], (k - k % 1000)]);
                }
              }
              series.push(timeSeries);
              return $q.when({data: series});
            };

          };

          var getHostAppIdData = function(target) {
            var precision = target.shouldAddPrecision ? '&precision=' + target.precision : '';
            var rate = target.shouldComputeRate ? '._rate._' : '._';
            return backendSrv.get(self.url + '/ws/v1/timeline/metrics?metricNames=' + target.metric + rate +
                target.aggregator + "&hostname=" + target.hosts + '&appId=' + target.app + '&startTime=' + from +
                '&endTime=' + to + precision).then(
                getMetricsData(target)
            );
          };

          var getServiceAppIdData = function(target) {
            var templatedHost = (_.isEmpty(templateSrv.variables)) ? "" : templateSrv.variables[0].options.filter(function(host)
              { return host.selected; }).map(function(hostName) { return hostName.value; });
            var precision = target.shouldAddPrecision ? '&precision=' + target.precision : '';
            var rate = target.shouldComputeRate ? '._rate._' : '._';
            return backendSrv.get(self.url + '/ws/v1/timeline/metrics?metricNames=' + target.metric + rate
              + target.aggregator + '&hostname=' + templatedHost + '&appId=' + target.app + '&startTime=' + from +
              '&endTime=' + to + precision).then(
              getMetricsData(target)
            );
          };

          // Time Ranges
          var from = Math.floor(options.range.from.valueOf() / 1000);
          var to = Math.floor(options.range.to.valueOf() / 1000);
          var metricsPromises = _.map(options.targets, function(target) {
              console.debug('target app=' + target.app + ',' +
                'target metric=' + target.metric + ' on host=' + target.hosts);
              if (!!target.hosts) {
                return getHostAppIdData(target);
              } else {
                return getServiceAppIdData(target);
              }
            });

          return $q.all(metricsPromises).then(function(metricsDataArray) {
            var data = _.map(metricsDataArray, function(metricsData) {
              return metricsData.data;
            });
            var metricsDataResult = {data: _.flatten(data)};
            return $q.when(metricsDataResult);
          });
        };

        /**
         * AMS Datasource  List Series.
         */
        AmbariMetricsDatasource.prototype.listSeries = function (query) {
          // wrap in regex
          if (query && query.length > 0 && query[0] !== '/') {
            query = '/' + query + '/';
          }
          return $q.when([]);
        };

        /**
         * AMS Datasource Templating Variables.
         */
        AmbariMetricsDatasource.prototype.metricFindQuery = function (query) {
          var interpolated;
          try {
            interpolated = templateSrv.replace(query);
          } catch (err) {
            return $q.reject(err);
          }
          return this.doAmbariRequest({
                method: 'GET',
                url: '/ws/v1/timeline/metrics/' + interpolated
              })
              .then(function (results) {
                //Remove fakehostname from the list of hosts on the cluster.
                var fake = "fakehostname"; delete results.data[fake];
                return _.map(_.keys(results.data), function (hostName) {
                  return {
                        text: hostName,
                        expandable: hostName.expandable ? true : false
                      };
                });
              });
        };

        /**
         * AMS Datasource  - Test Data Source Connection.
         *
         * Added Check to see if Datasource is working. Throws up an error in the
         * Datasources page if incorrect info is passed on.
         */
        AmbariMetricsDatasource.prototype.testDatasource = function () {
          return backendSrv.datasourceRequest({
            url: this.url + '/ws/v1/timeline/metrics/metadata',
            method: 'GET'
          }).then(function(response) {
            console.log(response);
            if (response.status === 200) {
              return { status: "success", message: "Data source is working", title: "Success" };
            }
          });
        };

        /**
         * AMS Datasource - Suggest AppId.
         *
         * Read AppIds from cache.
         */
        AmbariMetricsDatasource.prototype.suggestApps = function (query) {
          console.log(query);

          appIds = appIds.sort();
          var appId = _.map(appIds, function (k) {
            return {text: k};
          });
          return $q.when(appId);
        };

        /**
         * AMS Datasource - Suggest Metrics.
         *
         * Read Metrics based on AppId chosen.
         */
        AmbariMetricsDatasource.prototype.suggestMetrics = function (query, app) {
          if (!app) {
            return $q.when([]);
          }
          var metrics = allMetrics.filter(function(item) {
            return (item.app === app);
          });
          var keys = [];
          _.forEach(metrics, function (k) { keys.push(k.metric); });
          keys = _.map(keys,function(m) {
            return {text: m};
          });
          keys = _.sortBy(keys, function (i) { return i.text.toLowerCase(); });
          return $q.when(keys);
        };

        /**
         * AMS Datasource - Suggest Hosts.
         *
         * Query Hosts on the cluster.
         */
        AmbariMetricsDatasource.prototype.suggestHosts = function (query) {
          console.log(query);
          return this.doAmbariRequest({method: 'GET', url: '/ws/v1/timeline/metrics/hosts'})
            .then(function (results) {
              //Remove fakehostname from the list of hosts on the cluster.
              var fake = "fakehostname"; delete results.data[fake];
              return _.map(Object.keys(results.data), function (hostName) {
                return {text: hostName};
              });
            });
        };

        /**
         * AMS Datasource Aggregators.
         */
        var aggregatorsPromise = null;
        AmbariMetricsDatasource.prototype.getAggregators = function () {
          if (aggregatorsPromise) {
            return aggregatorsPromise;
          }
          aggregatorsPromise = $q.when([
            'avg', 'sum', 'min', 'max'
          ]);
          return aggregatorsPromise;
        };

        return AmbariMetricsDatasource;
      });
    }
);