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
package org.apache.ambari.server.controller.metrics;

import org.apache.ambari.server.controller.spi.SystemException;

import static org.apache.ambari.server.controller.metrics.MetricsServiceProvider.MetricsService;

public interface MetricHostProvider {
  /**
   * Get the metrics server host name for the given cluster name.
   *
   * @param clusterName  the cluster name
   *
   * @return the metrics server
   *
   * @throws org.apache.ambari.server.controller.spi.SystemException if unable to get the metrics server host name
   */
  public String getCollectorHostName(String clusterName, MetricsService service) throws SystemException;

  /**
   * Get the host name for the given cluster name and component name.
   *
   * @param clusterName   the cluster name
   * @param componentName the component name
   * @return the host name
   * @throws org.apache.ambari.server.controller.spi.SystemException
   *          if unable to get the JMX host name
   */
  public String getHostName(String clusterName, String componentName) throws SystemException;

  /**
   * Get the metrics server port for the given cluster name.
   *
   * @param clusterName  the cluster name
   *
   * @return the metrics server
   *
   * @throws org.apache.ambari.server.controller.spi.SystemException if unable to get the metrics server port
   */
  public String getCollectorPort(String clusterName, MetricsService service) throws SystemException;

  /**
   * Get the status of metrics server host for the given cluster name.
   *
   * @param clusterName the cluster name
   *
   * @return true if heartbeat with metrics server host wasn't lost
   *
   * @throws SystemException if unable to get the status of metrics server host
   */
  public boolean isCollectorHostLive(String clusterName, MetricsService service) throws SystemException;

  /**
   * Get the status of metrics server component for the given cluster name.
   *
   * @param clusterName the cluster name
   *
   * @return true if metrics server component is started
   *
   * @throws SystemException if unable to get the status of metrics server component
   */
  public boolean isCollectorComponentLive(String clusterName, MetricsService service) throws SystemException;
}
