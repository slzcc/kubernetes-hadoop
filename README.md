# kubernetes-hadoop

通过 Kubernetes  部署 Hadoop HA 模式，并支持 ZKCF。

请修改 `deploy/hostMachine` 部署配置以 `hostNetwork` 模式部署。

Taint 配置如下：

```
$ kubectl label nodes <nodes> zhangyue-ops.com/schedule-hbase-01=true
$ kubectl taint nodes <nodes> application=bigdata:NoSchedule
$ kubectl taint nodes <nodes> organization=user:NoSchedule
$ kubectl taint nodes <nodes> special=true:NoSchedule
```
