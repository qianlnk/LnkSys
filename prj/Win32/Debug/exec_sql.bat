::
:: xuxiaoxi by 20121024 v1.1
::
:: 20121027：修改支持含空格的文件名
::
:: [isqlw][osql][isql] -U sa -P -S 127.0.0.1 -i inputfile -o outputfile
:: [isql]不支持unicode文件;[osql]支持unicode文件;[isqlw]相当于查询分析器
:: osql命令：osql -E -d DataBaseName -i InputFile >> outputfile
:: 其中 >> 重定向追加输出，

@echo OFF
::echo 将提交当前目录以及子目录下所有*.sql文件到SQL查询分析器执行
::set /p p=是否提交？(Y/N):
::if "%p%"=="y" (
  :: 获取当前时间
:begin
  echo %Date:~0,10% %time:~0,5% >> %CD%\Log_ExecSql.txt 
  echo. >> %CD%\Log_ExecSql.txt
  :: 开始提交sql脚本
  for /r .\ %%i in (*.sql) do (
    echo 提交 %%i
    echo.提交 %%i 到SQL查询分析器执行 >> %CD%\Log_ExecSql.txt 
    SQLCMD -S 127.0.0.1 -E -d LnkSys -i "%%i" -o %CD%\Log.txt
    type %CD%\Log.txt & echo. 
    type %CD%\Log.txt >> %CD%\Log_ExecSql.txt    
    echo. >> %CD%\Log_ExecSql.txt  
  )
  if exist %CD%\Log.txt del %CD%\Log.txt
::pause
::) else if "%p%"=="Y" goto begin

