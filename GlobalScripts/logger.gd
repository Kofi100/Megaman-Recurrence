extends Node
#class_name GlobalLogger
enum LogLevel{WARN,DEBUG,INFO}
func log_basic(logLevel:LogLevel,source:Variant,message:String):
	var log_color=""
	var log_type_text=""
	var time_dictionary=Time.get_datetime_dict_from_system()
	var time_string:String =" %s/%s/%s : %s:%s:%s" %[
	time_dictionary.day,
	time_dictionary.month,time_dictionary.year,
	pad_zeros_variables(time_dictionary.hour),
	pad_zeros_variables(time_dictionary.minute),
	pad_zeros_variables(time_dictionary.second)]
	#GlobalLogger.info
	#print("[INFO] %s | %s :%s"% [time_string,source,message])
	

	match logLevel:
		LogLevel.WARN:
			log_color="red";log_type_text="WARN"
		LogLevel.DEBUG:
			log_color="cyan";log_type_text="DEBUG"
		LogLevel.INFO:
			log_color="green";log_type_text="INFO"
	
	print_rich("[color=%s][%s] %s | %s :%s [/color]"% [log_color,log_type_text,time_string,source,message])
func pad_zeros_variables(variable):
	return str(variable).pad_zeros(2)
func info(source:Variant,message:String):
	#var time_dictionary=Time.get_datetime_dict_from_system()
	#var time_string:String =" %s/%s/%s : %s:%s:%s" %[time_dictionary.day,time_dictionary.month,time_dictionary.year,time_dictionary.hour,time_dictionary.minute,time_dictionary.second]
	#print("[INFO] %s | %s :%s"% [time_string,source,message])
	#print_rich("[color=%s][INFO] %s | %s :%s [/color]"% [time_string,source,message])
	log_basic(LogLevel.INFO,source,message)

func debug(source:Variant,message:String):
	log_basic(LogLevel.DEBUG,source,message)

func warn(source:Variant,message:String):
	log_basic(LogLevel.WARN,source,message)
