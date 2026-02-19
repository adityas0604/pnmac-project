variable "cron_jobs" {
  type = map(object({
    handler     = string
    schedule    = string
    timeout     = number
    memory_size = number
  }))
  default = {
    ingestDailyWinner = {
      handler     = "cron/handler.ingestDailyWinnerCron"
      schedule    = "cron(10 5 ? * TUE-SAT *)"
      timeout     = 120
      memory_size = 256
    }
    // can add more cron jobs here
  }
}
