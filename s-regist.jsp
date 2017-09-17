<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!doctype html>
<html lang="en">
<style type="text/css">
</style>
<head>
	<meta charset="utf-8">
	<link rel="stylesheet" type="text/css" href="jqeasyui/themes/default/easyui.me.css">
	<link rel="stylesheet" type="text/css" href="jqeasyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="system/css/icon.css">
    <script type="text/javascript" src="jqeasyui/jquery.min.js"></script>
    <script type="text/javascript" src="jqeasyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="jqeasyui/easyui-lang-zh_CN.js"></script>	
	<script type="text/javascript" src="system/easyui_functions.js"></script>
</head>

<body style="margin: 2px 2px 2px 2px;">
<div id="main" style="margin:50px 200px 20px 370px;">

</div>

<script>
$(document).ready(function() {
     myKeyDownEvent('');		
 	 mySelectOnFocus();
     myForm('myForm1','main','学生注册',0,0,300,500,'collapse;max;min;close');
	 myTextField('stuid','myForm1','学号：',70,33*0+14,18,0,200,'','');
	 myTextField('stuname','myForm1','姓名：',70,33*1+14,18,0,200,'','');
	 myTextField('gender','myForm1','性别：',70,33*2+14,18,0,200,'','');
	 myTextField('classid','myForm1','班级编号：',70,33*3+14,18,0,200,'','');
	 myTextField('phone','myForm1','联系方式：',70,33*4+14,18,0,200,'','');
	 myButton("submit","myForm1",'提交',190,200,24,60,'','');
	 myButton("reset","myForm1",'重置',190,270,24,60,'','');
	 $("#submit").bind('click', function(e){ 
	        fnSave(e); 
	    });
	   	 
	 function fnSave(){
		var sql="select stuid from mytushu where stuid='"+$("#stuid").textbox('getValue')+"' ";
		console.log(sql);
		var result=[];//定义全局变量
		$.ajax({     
			type: "Post",     
			url: "system/easyui_execSelect.jsp",     
			//contentType: "application/json; charset=utf-8",     
			//dataType: "json", 
			data: {database: sysdatabasestring, selectsql: sql}, 
			async: false, method: 'post',    
			success: function(data) {     
				//返回的数据用data获取内容,直接复制到客户端数组result   
				console.log(data);   
				eval("result="+data+";");  //or var result=jQuery.parseJSON(data);
			},    
			error: function(err) {     
				console.log(err);     
			}     
		});	
        
		if (result.length!=0){
			$.messager.alert('系统提示','<br>&nbsp;该学号已存在！','error');
		}
		}
             
		$.extend($.fn.validatebox.defaults.rules, {
		date: {
			validator: function(value, param){
				var now = new Date();
				var d1 = new Date('1949-10-01');
				var d2 = new Date(now.getFullYear(), now.getMonth(), now.getDate());
				var d3 = now.getFullYear()+'-'+now.getMonth()+'-'+now.getDate();
				return d1<=new Date(value) && new Date(value)<=d2;
               },
              
           },
		CHS:{  //验证汉字
			validator:function(value){
				return /^[\u0391-\uFFE5]+$/.test(value);
			},
			message:"教师姓名只能输入汉字！"
		},
		integer : {// 验证整数 
			validator : function(value) { 
				return /^[+]?[1-9]+\d*$/i.test(value); 
			}, 
			message : '学号只能输入数字！' 
		}, 	             
	});
		function fnValidation(){
		var errormsg=[];  //存放数据验证发现的错误信息
		//先判断各个控件是否符合格式要求
		if (!$("#stuid").textbox('isValid')) errormsg.push('学号输入错误！');
		if (!$("#stuname").textbox('isValid')) errormsg.push('姓名输入错误！');
		var s1=$("#stuid").textbox('getValue');
		var s2=$("#stuname").textbox('getValue');
		if (s1.length==0) errormsg.push('学号不能为空！');
		if (s2.length==0) errormsg.push('姓名不能为空！');
		//数据验证结束
		if (errormsg.length>0){
			var str='';
			for (var i=0;i<errormsg.length;i++){
				str+='<br>';
				if (i>0) str+='<span style="padding:0px 0px 0px 42px;">'+errormsg[i]+'</span>';
				else str+=errormsg[i];
			}
			$.messager.alert('系统提示','数据验证发现下列错误，提交失败！<br>'+str,'error');
		}	
	}
	
	
	
	});
	
</script>

</body>
</html>

