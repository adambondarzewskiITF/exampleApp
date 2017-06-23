session_id <- 1
logDir <- './Logs/'

registerLogger("pkg_logger_info", create_logger("info", "INFO",
                                                                   log_file = paste0(logDir, session_id, ".info")))
registerLogger("pkg_logger_debug", create_logger("debug", "DEBUG",
                                                                    log_file = paste0(logDir, session_id, ".debug")))
registerLogger("pkg_logger_error", create_logger("error", "ERROR",
                                                                    log_file = paste0(logDir, session_id, ".err")))
registerLogger("pkg_logger_warn",create_logger("warning", "WARNING",
                                                                  log_file = paste0(logDir, session_id, ".warning")))

addHandler(writeToConsole)
