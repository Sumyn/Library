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
<body id='main' class="easyui-layout" data-options="fit:true" style="margin: 1px 1px 1px 1px;">
    <div id='top' class='easyui-panel' data-options="region:'north'" style="overflow:hidden; background-color: #E0ECFF; height:30px; padding: 1px 1px 1px 10px;">
		<a href="#" class="btn-separator"></a>
		<a href="#" id="btnrefresh" xtype="button" class="easyui-linkbutton" data-options="iconCls:'refreshIcon',plain:true, onClick:fnRefresh1" style=" margin:1px 1px 1px 100px;">刷新</a>
	</div>
    <div id='middle' class='easyui-panel' data-options="region:'center'" style="height:20px; overflow:auto; padding:5px 0px 0px 5px;">
	</div>
    <div id='bottom' class='easyui-panel' data-options="region:'south'" style="height:300px; overflow:auto; padding:5px 0px 0px 5px;">
	</div> 
<script>
     var errormsg=[];
    $(document).ready(function() {
        var gendersource=[{'bocatename':'教科书'},{'bocatename':'小说'}];
    
        document.onkeypress=myBanBackSpace;
		document.onkeydown=myBanBackSpace;
        
		myForm('myForm1','bottom','图书信息',0,0,260,900,'close;collapse;min;max');
		myFieldset('myFieldset1','myForm1','基本信息',010,10,170,400);
		myFieldset('myFieldset2','myForm1','其它信息',010,430,170,400);
		myTextField('stuid','myFieldset1','学生编号：',70,33*0+20,12,0,300,'');
		myTextField('stuname','myFieldset1','学生姓名：',70,33*1+20,12,0,300,'');
		myTextField('bookid','myFieldset1','图书编号：',70,33*2+20,12,0,300,'');
		myTextField('bookname','myFieldset1','图书名称：',70,33*3+20,12,0,300,'');
		myTextField('categoryname','myFieldset2','图书类别：',70,33*0+20,12,0,300,'');
		myTextField('pressname','myFieldset2','出版社：',70,33*1+20,12,0,300,'');
		myTextField('writer','myFieldset2','作者：',70,33*2+20,12,0,300,'');
		myTextField('country','myFieldset2','国家：',70,33*3+20,12,0,300,'');
		myButton("reset","myForm1",'重置',200,271,24,70,'','');
		
	
		$("#reset").on('click',function(){
			myreSetForm();   //重置时调用函数myreSetForm
		});
		
		$("#myWin1").window({
			closable:true, 
			collapsible:true, 
			resizable:true,
			draggable:true, 
			modal:true, //表示该窗口为模态窗口，也就是说，在打开子窗口时，用户再也无法点击操作主窗口中的任何控件（单窗体）
			maximizable:false
		});

		//数据验证
		$('#id').textbox({
			validType:"integer"	//自定义验证规则名，下同	（integer为整数）
		});
		$('#name').textbox({
			validType:"CHS"		
		});
		

		//////////////////////////////////////////////
		//借书窗口
		//(id,parent,text,top,left,height,width,icon,style,event)
		myButton("bolend","top",'借书',4,10,24,60,'','');
		//myButton("refresh","top",'刷新',4,100,24,60,'','');
		myWindow('myaddWin1','借书信息',0,0,460,400,'modal;drag');
		myTextField('mystuid','myaddWin1','学号：',70,36*0+20,18,0,160,'');
		myTextField('mystuname','myaddWin1','姓名：',70,36*1+20,18,0,160,'');
		myTextField('mybookid','myaddWin1','图书编号：',70,36*2+20,18,0,160,'');
		myTextField('mybookname','myaddWin1','书名：',70,36*3+20,18,0,160,'');
		myComboField('mycatename','myaddWin1','图书类别：',70,36*4+20,18,0,160,'教科书;小说','');
		myTextField('myprename','myaddWin1','出版社：',70,36*5+20,18,0,160,'');
		myTextField('bowriter','myaddWin1','作者：',70,36*6+20,18,0,160,'');
		myTextField('bocountry','myaddWin1','国家：',70,36*7+20,18,0,160,'');
		myButton("sure3","myaddWin1",'提交',310,200,24,60,'','');
		myButton("cancel3","myaddWin1",'取消',310,270,24,60,'','');
		
		$('#mystuid').textbox({
			validType:"integer"	//自定义验证规则名，下同	（integer为整数）
		});
		$('#mybookid').textbox({
			validType:"integer"	//自定义验证规则名，下同	（integer为整数）
		});
		
	
		$("#bolend").bind('click', function(e){//点击取消按钮
			$("#myaddWin1").window('open');//点击取消按钮后窗口关闭
		});
		$("#sure3").bind('click', function(e){ 
		     //fnRefresh(e);
		     fnSave1(e); 
		  }); 
		$("#cancel3").bind('click', function(e){//点击取消按钮
			$("#myaddWin1").window('close');//点击取消按钮后窗口关闭
		});
		
   		
		/////////////////////////////////////////////////////////////
		//定义数据网格
		var pmyGrid1={};
		pmyGrid1.id='myGrid1';
		pmyGrid1.parent='middle';
		pmyGrid1.staticsql="select stuid,stuname,bookID,bookName,categoryname,pressname,writer,country from mytushu";
		pmyGrid1.activesql=pmyGrid1.staticsql;
		pmyGrid1.gridfields='[@c%c#110,2]姓名/stuname;[@l%c#90]图书编号/bookid;[@c%c#110,2]书名/bookname;';
		pmyGrid1.gridfields+='[%d#90@c]类别/categoryname;[@c#100]出版社/pressname;[110]作者/writer;[110]国家/country';
		pmyGrid1.fixedfields='[@l%c#90]学号/stuid';
		pmyGrid1.title='学生借书';
		pmyGrid1.menu='myMenu1';
		pmyGrid1.checkbox='single';
		pmyGrid1.pagesize=10;
		pmyGrid1.keyfield='stuid';
		pmyGrid1.rownumbers=true;
		pmyGrid1.collapsible=true;
		pmyGrid1.height=335;
		pmyGrid1.width=1100;
		pmyGrid1.rowindex=0;
		//定义grid
		myGrid(pmyGrid1);
		
		//点击网格某行时把该行对应的数据从表单中显示
		$("#myGrid1").datagrid({
		    onSelect: function (index,data){
		    var result=data;
		    $("#stuid").textbox('setValue',result.stuid);
		    $("#stuname").textbox('setValue',result.stuname);
		    $("#bookid").textbox('setValue',result.bookid);
		    $("#bookname").textbox('setValue',result.bookname);
		    $("#categoryname").textbox('setValue',result.categoryname);
		    $("#pressname").textbox('setValue',result.pressname);
		    $("#writer").textbox('setValue',result.writer);
		    $("#country").textbox('setValue',result.country);
		    }
		 });
		
		
		//初始化，显示第一页记录
		myLoadGridData(pmyGrid1,1);
		var tmp='';
		for (var i=0;i<pmyGrid1.columns.length;i++){
			if (tmp!='') tmp+=';';
			tmp+=pmyGrid1.columns[i].title;
			};
	
	   // $('#myGrid1').datagrid( "loadData", source );
		 
	    });	//基本定义结束
	////////////////////////////////////////////////////////////////////////////////////////////    
	  	//借书后刷新工具栏的刷新按钮
		function fnRefresh1(){ 
		var pmyGrid1={};
		pmyGrid1.id='myGrid1';
		pmyGrid1.parent='middle';
		pmyGrid1.staticsql="select stuid,stuname,bookID,bookName,categoryname,pressname,writer,country from mytushu";
		pmyGrid1.activesql=pmyGrid1.staticsql;
		pmyGrid1.gridfields='[@c%c#110,2]姓名/stuname;[@l%c#90]图书编号/bookid;[@c%c#110,2]书名/bookname;';
		pmyGrid1.gridfields+='[%d#90@c]类别/categoryname;[@c#100]出版社/pressname;[110]作者/writer;[110]国家/country';
		pmyGrid1.fixedfields='[@l%c#90]学号/stuid';
		pmyGrid1.title='学生借书';
		pmyGrid1.menu='myMenu1';
		pmyGrid1.checkbox='single';
		pmyGrid1.pagesize=10;
		pmyGrid1.keyfield='stuid';
		pmyGrid1.rownumbers=true;
		pmyGrid1.collapsible=true;
		pmyGrid1.height=335;
		pmyGrid1.width=1100;
		pmyGrid1.rowindex=0;
		//定义grid
		myGrid(pmyGrid1);

		myLoadGridData(pmyGrid1,1);
	    }
 

	//借书页面保存数据
	function fnSave1(){
	      fnValidation1();
	      if(errormsg1.length==0)
	      {
	        var sql="insert into mytushu (stuid,stuname,bookid,bookname,categoryname,pressname,writer,country) values(";
    		  sql+="'"+$("#mystuid").textbox('getValue')+"',";
    		  sql+="'"+$("#mystuname").textbox('getValue')+"',";
    		  sql+="'"+$("#mybookid").textbox('getValue')+"',";
    		  sql+="'"+$("#mybookname").textbox('getValue')+"',";
    		  sql+="'"+$("#mycatename").combobox('getValue')+"',";
    		  sql+="'"+$("#myprename").textbox('getValue')+"',";
    		  sql+="'"+$("#bowriter").textbox('getValue')+"',";
    		  sql+="'"+$("#bocountry").textbox('getValue')+"'";
    		  sql+=")";
    		var sqlx="insert into mybooks (id,name,parentnodeid,isparentflag,ancester,level) values(";
    		  sqlx+="'"+$("#mybookid").textbox('getValue')+"',";
    		  sqlx+="'"+$("#mybookname").textbox('getValue')+"',";
    		  sqlx+="'"+$("#mystuid").textbox('getValue')+"',";
    		  sqlx+="'0',";
    		  sqlx+="'"+$("#mystuid").textbox('getValue')+"#',";
    		  sqlx+="'2'";
    		  sqlx+=")";
    		 var result=myRunUpdateSql(sysdatabasestring,sqlx);
    		  //alert(sql);
    		 var result=myRunUpdateSql(sysdatabasestring,sql);
    	 	 if(result.error=='')
    	     {
    	         alert('借书成功！');
    	         $("#myaddWin1").window('close');
    	     }   
    	    }
    	 }
    
    //借书验证函数
    	 function fnValidation1(){
         errormsg1=[];
         if (!$("#mystuid").textbox('isValid')) errormsg1.push('学号输入错误！');
		 if (!$("#mybookid").textbox('isValid')) errormsg1.push('图书编号错误！');
		 var s6=$("#mystuid").textbox('getValue');
		 var s7=$("#mybookid").textbox('getValue');
		 if (s6.length==0) errormsg1.push('学号不能为空！');
		 if (s7.length==0) errormsg1.push('图书编号不能为空！');
		 
		 var sql="select stuid from mystudents where stuid='"+s6+"' and checkout='已审核'";
		 var result=myRunSelectSql(sysdatabasestring,sql);  //调用函数myRunSelectSql把值赋给result
		 if (result.length==0){
			errormsg1.push('您未注册或未审核通过！');
		}
		 
		 if (errormsg1.length>0){
			var str='';
			for (var i=0;i<errormsg1.length;i++){
				str+='<br>';
				if (i>0) str+='<span style="padding:0px 0px 0px 42px;">'+errormsg1[i]+'</span>';
				else str+=errormsg1[i];
			
			}
			$.messager.alert('系统提示','数据验证发现下列错误，提交失败！<br>'+str,'error');
		}	
	}
	
	
    	 ///////////////////////////////////////////////////////////
	
	//数据验证
		$.extend($.fn.validatebox.defaults.rules, {
		CHS:{  //验证汉字
			validator:function(value){
				return /^[\u0391-\uFFE5]+$/.test(value);
			},
			message:"只能输入汉字！"
		},
		integer : {// 验证整数 
			validator : function(value) { 
				return /^[+]?[1-9]+\d*$/i.test(value); 
			}, 
			message : '只能输入数字！' 
		}, 	             
	});
	//////////////////////////////////////////////////////////////////////////
	function getParam(){
	   var c1=window.location.href.split('&')[1];
	   return c1;
	   }
	
</script>
</body>
</html>
