{
  new(this): {
    groups: [
      {
        name: this.config.uid + '-alerts',
        rules: [
          {
            alert: 'IBMDB2HighLockWaitTime',
            expr: |||
              sum without (job) (ibm_db2_lock_wait_time) > %(alertsHighLockWaitTime)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'The average amount of time waiting for locks to become free is abnormally large.',
              description:
                (
                  'The average amount of time waiting for locks to become free is {{$labels.value}}ms for {{$labels.database_name}} which is above the threshold of %(alertsHighLockWaitTime)sms.'
                ) % this.config,
            },
          },
          {
            alert: 'IBMDB2HighNumberOfDeadlocks',
            expr: |||
              sum without (job) (increase(ibm_db2_deadlock_total[5m])) > %(alertsHighNumberOfDeadlocks)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There are deadlocks occurring in the database.',
              description:
                (
                  'The number of deadlocks is at {{$labels.value}} for {{$labels.database_name}} which is above the threshold of %(alertsHighNumberOfDeadlocks)s.'
                ) % this.config,
            },
          },
          {
            alert: 'IBMDB2LogUsageReachingLimit',
            expr: |||
              100 * sum without (job,log_usage_type) (ibm_db2_log_usage{log_usage_type="used"}) / sum without (job,log_usage_type) (ibm_db2_log_usage{log_usage_type="available"}) > %(alertsLogUsageReachingLimit)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'The amount of log space available for the DB2 instance is running out of space, rotate logs or delete unnecessary storage usage.',
              description:
                (
                  'The amount of log space being used by the DB2 instance is at {{$labels.value}}%% which is above the threshold of %(alertsLogUsageReachingLimit)s%%.'
                ) % this.config,
            },
          },
        ],
      },
    ],
  },
}
