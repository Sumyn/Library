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
<div id="main" style="margin:50px 20px 20px 200px;">
     <label id='stuid_label'>账号：</label>
     <div id="stuid_div"><input class="easyui-textbox" type="text" id="stuid"></input></div>
     <label id='passage1_label'>密码：</label>
     <div id="passage1_div"><input class="easyui-textbox" type="password" id="passage1"></input></div>
</div> 

<script>
$(document).ready(function() {
     myKeyDownEvent('');		
 	 mySelectOnFocus();
     myForm('myForm1','main','用户登录',0,0,450,320,'collapse;max;min;close');
	 //myTextField('stuid','myForm1','账号：',60,40,15,30,150,'');
	// myTextField('passage1','myForm1','密码：',60,100,15,30,150,'');
	 myFocus('stuid');		
     myButton('stulogin','myForm1','学生登录',220,50,35,190,'','');
	 myButton('maglogin','myForm1','管理员登录',270,50,35,190,'','');
	 myButton('regist','myForm1','注册',320,50,35,190,'','');
	 
	 $("#stuid_label").css({position: "absolute", top:"123px", left:"216px", width:"60px", "text-align":"left", "z-index":2});
	$("#stuid_div").css({position: "absolute", top:"120px", left:"266px",height:"190px",width:"90px","z-index":2});
     
     $("#passage1_label").css({position: "absolute", top:"190px", left:"216px", width:"60px", "text-align":"left", "z-index":2});
	$("#passage1_div").css({position: "absolute", top:"193px", left:"266px",height:"90px",width:"40px","z-index":2});
	
	/////////////////////////////////////////////////////////////////////
	//注册窗口 
	 $("#myWin1").window({
			closable:true, 
			collapsible:true, 
			resizable:true,
			draggable:true, 
			modal:true, //表示该窗口为模态窗口，也就是说，在打开子窗口时，用户再也无法点击操作主窗口中的任何控件（单窗体）
			maximizable:false
		});
	//注册框控件		
	myWindow('myWin1','学生注册',100,600,300,355);	
	myTextField('id','myWin1','学号：',70,33*0+14,18,0,200,'','');
	myTextField('name','myWin1','姓名：',70,33*1+14,18,0,200,'','');
	myTextField('passage','myWin1','密码：',70,33*2+14,18,0,200,'','');
	myTextField('classid','myWin1','班级编号：',70,33*3+14,18,0,200,'','');
	myTextField('phone','myWin1','联系方式：',70,33*4+14,18,0,200,'','');
	myButton("sure1","myWin1",'提交',190,200,24,60,'','');
	myButton("cancel1","myWin1",'取消',190,270,24,60,'','');
	$('#id').textbox({
			validType:"integer"	
		});
	$('#name').textbox({
			validType:"CHS"		
		});
	$("#cancel1").bind('click', function(e){
			$("#myWin1").window('close');
		});
	////////////////////////////////////////////////////////////////////////////
	$("#regist").bind('click', function(e){
			$("#myWin1").window('open');
		});
		
	 $("#stulogin").bind('click', function(e){ 
	        fnRefresh(); 
	     
	    });
	 $("#maglogin").bind('click',function(){
			fnRefresh1();   
		});
	$("#sure1").bind('click', function(e){ 
		     fnSave(e); 
		  });
    /////////////////////////////////////////////////////////////
    //学生登录函数
	 function fnRefresh(){
		var sql="select * from mystudent where stuid='"+$("#stuid").textbox('getValue')+"' and passage='"+$("#passage1").textbox('getValue')+"' and checkout='已审核' ";
		
		console.log(sql);
		var result=[];//定义全局变量
		$.ajax({     
			type: "Post",     
			url: "system/easyui_execSelect.jsp",     
			data: {database: sysdatabasestring, selectsql: sql}, 
			async: false, method: 'post',    
			success: function(data) {     
				console.log(data);   
				eval("result="+data+";"); 
			},     
			error: function(err) {     
				console.log(err); 
				console.log(sql);    
			}     
		});	
		//alert(sql);
		if (result.length==0){
			$.messager.alert('系统提示','<br>&nbsp;账号错误！','error');
		}else{
		     var url="http://127.0.0.1:8088/jQDemos/s-booklend.jsp";
             window.location.href=url;
             }
      } 
 //////////////////////////////////////////////////////////////////////////
   //管理员登录函数        
    function fnRefresh1(){
		var sql="select * from mymanage where magid='"+$("#stuid").textbox('getValue')+"' and passage='"+$("#passage1").textbox('getValue')+"' ";
		console.log(sql);
		var result=[];//定义全局变量
		$.ajax({     
			type: "Post",     
			url: "system/easyui_execSelect.jsp",     
			data: {database: sysdatabasestring, selectsql: sql}, 
			async: false, method: 'post',    
			success: function(data) {     
				console.log(data);   
				eval("result="+data+";"); 
			},     
			error: function(err) {     
				console.log(err);     
			}     
		});	
        
		if (result.length==0){
			$.messager.alert('系统提示','<br>&nbsp;密码错误或未注册！','error');
		}else{
		      var url="http://127.0.0.1:8088/jQDemos/m-studentInformation.jsp";
		      window.location.href=url;
             }
      }
         
    ///////////////////////////////////////////////////////////////////////
    //格式验证       
	$.extend($.fn.validatebox.defaults.rules, {
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
	///////////////////////////////////////////////////////////////////////
	function fnSave(){
	      fnValidation();
	      if(errormsg.length==0)
	      {
	        var sql="insert into mystudent (stuid,stuname,passage,classid,phone,checkout) values(";
    		  sql+="'"+$("#id").textbox('getValue')+"',";
    		  sql+="'"+$("#name").textbox('getValue')+"',";
    		  sql+="'"+$("#passage").textbox('getValue')+"',";
    		  sql+="'"+$("#classid").textbox('getValue')+"',";
    		  sql+="'"+$("#phone").textbox('getValue')+"',";
    		  sql+="'未审核'";
    		  sql+=")";
    		  //alert(sql);
    		 var result=myRunUpdateSql(sysdatabasestring,sql);
    	 		if(result.error=='')
    	     		{
    	         alert('注册成功，等待管理员审核！');
    	         $("#myWin1").window('close');
    	     }else
    	     {
    	  	     alert('注册失败');
    	     }   
    	    }
    	 }
   /////////////////////////////////////////////////////////////////////////
	//验证后判断
	function fnValidation(){
       errormsg=[];
		if (!$("#id").textbox('isValid')) errormsg.push('学号输入错误！');
		if (!$("#name").textbox('isValid')) errormsg.push('姓名输入错误！');
		if (!$("#passage").textbox('isValid')) errormsg.push('性别输入错误！');
		if (!$("#classid").textbox('isValid')) errormsg.push('班级编号输入错误！');
		if (!$("#phone").textbox('isValid')) errormsg.push('联系方式格式错误！');
		
		var s1=$("#id").textbox('getValue');
		var s2=$("#name").textbox('getValue');
		var s3=$("#passage").textbox('getValue');
		var s4=$("#classid").textbox('getValue');
		var s5=$("#phone").textbox('getValue');
		
		if (s1.length==0) errormsg.push('学号不能为空！');
		if (s2.length==0) errormsg.push('姓名不能为空！');
		if (s3.length==0) errormsg.push('密码不能为空！');
		if (s4.length==0) errormsg.push('班级编号不能为空！');
		if (s5.length==0) errormsg.push('联系方式不能为空！');
		
		//验证编码是否重复
		var sql="select * from mystudent where stuid='"+s1+"'";
		var result=myRunSelectSql(sysdatabasestring,sql);  //调用函数myRunSelectSql把值赋给result
		if (result.length!=0){
			errormsg.push('该学号已存在！');
		}
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
	
	/*function getParam(){
	   var c1=window.location.href.split('&')[1];
	   return c1;*/
	
</script>

</body>
</html>
