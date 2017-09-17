<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<html>
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
<body style="margin: 2px 2px 2x 2px;">
<div id='main' class="easyui-layout" data-options="fit:true" style="padding: 30px 0px 1px 2px;" >
	<div id='top' class='easyui-panel' data-options="region:'north'" style="overflow:hidden; background-color: #E0ECFF; height:30px; padding: 1px 1px 1px 10px;">
		<a href="#" class="btn-separator"></a>
		<a href="#" id="btnedit" xtype="button" class="easyui-linkbutton" data-options="iconCls:'editIcon', plain:true, onClick:fnEdit" style="margin:1px 1px 1px 440px;">修改</a>
		<a href="#" id="btndelete" xtype="button" class="easyui-linkbutton" data-options="iconCls:'deleteIcon',plain:true, onClick:fnDelete" style="margin:1px 1px 1px 10px;">删除</a>
		<a href="#" class="btn-separator"></a>
		<a href="#" id="btnsave" xtype="button" class="easyui-linkbutton" data-options="iconCls:'saveIcon',plain:true, onClick:fnSave" style="margin:1px 1px 1px 10px;">保存</a>
		<a href="#" class="btn-separator"></a>
		<a href="#" id="btnrefresh" xtype="button" class="easyui-linkbutton" data-options="iconCls:'refreshIcon',plain:true, onClick:fnRefresh" style="margin:1px 1px 1px 10px;">刷新</a>
	</div>	
	<div id='left' class='easyui-panel' data-options="region:'west', split:true" style="overflow:auto; width:800px;">
	</div>
	<div id='middle' class='easyui-panel' data-options="region:'center', split:true" style="overflow:auto; width:500px">
	</div>
	

<script>
	$(document).ready(function(){   //jquery代码从此开始
	
	
	    //定义表单
	    //(id,parent,title,top,left,height,width,style)
	    myForm('myForm1','middle','图书信息',0,0,400,350,'close;collapse;min;max');
		myFieldset('myFieldset1','myForm1','基本信息',010,10,230,300);
		myTextField('id','myFieldset1','学号：',70,33*0+20,12,0,140,'');
		myTextField('name','myFieldset1','姓名：',70,33*1+20,12,0,140,'');
		myTextField('gender','myFieldset1','性别：',70,33*2+20,12,0,140,'');
		myTextField('classid','myFieldset1','班级编号：',70,33*3+20,12,0,140,'');
		myTextField('phone','myFieldset1','联系方式：',70,33*4+20,12,0,140,'');
		myTextField('checkout1','myFieldset1','审核状态：',70,33*5+20,12,0,140,'');
		//(id,parent,text,top,left,height,width,icon,style,event)
		myButton("check","myForm1",'审核',250,90,24,70,'','');
		
		$("#check").on('click',function(e){
		    fncheck(e);
		  });
		
		
		
	  	
	    var pmyGrid1={};
		pmyGrid1.id='myGrid1';
		pmyGrid1.parent='left';
		pmyGrid1.staticsql="select stuid,stuname,gender,classid,phone,checkout from mystudents";
		pmyGrid1.activesql=pmyGrid1.staticsql;
		pmyGrid1.gridfields='[@c%c#110,2]姓名/stuname;[@c%c#110,3]性别/gender;[@l%c#110,4]班级编号/classid;';
		pmyGrid1.gridfields+='[@l%c#110,5]联系方式/phone;[@c%c#110,6]审核状态/checkout';
		pmyGrid1.fixedfields='[@l%c#90]学号/stuid';
		pmyGrid1.title='学生信息';
		pmyGrid1.menu='myMenu1';
		pmyGrid1.checkbox='single';
		pmyGrid1.pagesize=10;
		pmyGrid1.keyfield='stuid';
		pmyGrid1.rownumbers=true;
		pmyGrid1.collapsible=true;
		pmyGrid1.height=400;
		pmyGrid1.width=700;
		pmyGrid1.rowindex=0;
		pmyGrid1.columns=[];
		//定义grid
		//调用函数取列名
		pmyGrid1.columns=[];
		pmyGrid1.scrollcolumns=[];
		pmyGrid1.fixedcolumns=[];
		pmyGrid1.checkboxcolumn=[];
		pmyGrid1.scrollcolumns=myGridColumns(pmyGrid1.gridfields);
		pmyGrid1.fixedcolumns=(pmyGrid1.fixedcolumns).concat(myGridColumns(pmyGrid1.fixedfields));;
		pmyGrid1.columns=(pmyGrid1.fixedcolumns).concat(pmyGrid1.scrollcolumns);
		if (pmyGrid1.checkbox!=''){
			pmyGrid1.checkboxcolumn.push({field:"checkboxid", width: 20, checkbox: true, align:"center"});
		}
		pmyGrid1.fixedcolumns=pmyGrid1.checkboxcolumn.concat(pmyGrid1.fixedcolumns)
		//定义网格及其属性
		var str='<div id="myGrid1" class="easyui-datagrid" data-options=""></div>';
		$("#"+pmyGrid1.parent).append($(str)); //$("#main").append($(str));
		if (pmyGrid1.width==0) pmyGrid1.width='100%';
		if (pmyGrid1.height==0) pmyGrid1.height='100%';
		var myGrid1=pmyGrid1.id;
		$("#myGrid1").datagrid({
			title: '&nbsp;'+pmyGrid1.title,
			width: pmyGrid1.width,
			height: pmyGrid1.height,
			iconCls: "panelIcon",
			nowrap: true,
			collapsible:false,
			pagePosition: 'bottom',  //top,both
			autoRowHeight: false,
			rownumbers:true,
			pageNumber: 1,
			striped: true,
			columns: [pmyGrid1.scrollcolumns],
			frozenColumns: [pmyGrid1.fixedcolumns]
		});
		if (pmyGrid1.checkbox='single'){
			$("#myGrid1").datagrid({singleSelect: true});	
		}else if (pmyGrid1.checkbox!=''){
			$("#myGrid1").datagrid({singleSelect: false});	
		}
		//////////////////////////////////////////////////////////////
		//点击网格取数据
		$("#myGrid1").datagrid({
		    onSelect: function (index,data){
		    var result=data;
		    $("#id").textbox('setValue',result.stuid);
		    $("#name").textbox('setValue',result.stuname);
		    $("#gender").textbox('setValue',result.gender);
		    $("#classid").textbox('setValue',result.classid);
		    $("#phone").textbox('setValue',result.phone);
		    $("#checkout1").textbox('setValue',result.checkout);

		    }
		 });
		 mySetFormReadonly(true);
		///////////////////////////////////////////////////////////
		
		
		
		
		//定义分页模式
		if (pmyGrid1.pagesize>0){ 
			$("#myGrid1").datagrid({
				pagination: true,
				pageSize: pmyGrid1.pagesize		
			});
			var pg = $("#"+pmyGrid1.id).datagrid("getPager");  
			(pg).pagination({  
				showPageList: false,  //是否显示设置每页显示行数的下拉框
				beforePageText: '第', //页数文本框前显示的汉字  
				afterPageText: '页    共 {pages} 页', 
				displayMsg: '当前显示{from}～{to}行，共{total}行',
				onRefresh:function(pageNumber,pageSize){  
					fnLoadGridData(pmyGrid1,pageNumber);  
				},  
				onChangePageSize:function(pageSize){  
					var opts = $('#myGrid1').datagrid('options');
					//var opts =$("#myGrid1").datagrid('getPager').data("pagination").options; 
					opts.pageSize=pageSize;				
					fnLoadGridData(pmyGrid1,1);  
				},  
				onSelectPage:function(pageNumber,pageSize){  
					var opts = $('#myGrid1').datagrid('options');
					//var opts =$("#myGrid1").datagrid('getPager').data("pagination").options; 
					opts.pageNumber=pageNumber;
					opts.pageSize=pageSize;				
					fnLoadGridData(pmyGrid1,pageNumber);  
				}  
			});
		}			
		//myGrid1定义结束
		//初始化，显示第一页记录
		//var opts = $('#myGrid1').datagrid('options');
		var opts =$("#myGrid1").datagrid('getPager').data("pagination").options; 
		opts.pageNumber=1;
		opts.pageSize=pmyGrid1.pagesize;			
		fnLoadGridData(pmyGrid1,1);
		//定义关键字下拉框和查询文本输入框
		var tmp='';  ////从网格中提取列标题作为下拉框选项
		for (var i=0;i<pmyGrid1.columns.length;i++){
			if (tmp!='') tmp+=';';
			tmp+=pmyGrid1.columns[i].title;
		}
		
		//(id,parent,label,labelwidth,top,left,height,width,items,value,style)
		myComboField('searchfield','top','选择关键字:',75,4,10,0,120,tmp,'','checkbox');
		//(id,parent,label,labelwidth,top,left,height,width,value,style)
		myTextField('searchtext','top','快速过滤：',75,4,220,0,120,'','');
		
		
		$('#searchtext').textbox({
			buttonIcon:'locateIcon',
			onClickButton: function(e){
				var xtext=$('#searchtext').textbox("getValue");
				var xfields=';'+$('#searchfield').combobox("getText")+';';
				//console.log(xtext+'---'+xfields);
				var wheresql='';
				for (var i=0;i<pmyGrid1.columns.length;i++){
					if (xfields.indexOf(';'+pmyGrid1.columns[i].title+';')>=0){
						if (wheresql!='') wheresql+=' or ';
						wheresql+=pmyGrid1.columns[i].field+" like '%"+xtext+"%'";
					}
				}	
				if (wheresql!='' && xtext!='') pmyGrid1.activesql='select * from ('+pmyGrid1.staticsql+') as p where '+wheresql;
				else pmyGrid1.activesql=pmyGrid1.staticsql;
				//console.log(pmyGrid1.activesql);
				var opts =$("#myGrid1").datagrid('getPager').data("pagination").options; 
				opts.pageNumber=1;				
				fnLoadGridData(pmyGrid1,1);            	
			}
		}); 

		//以下为函数
		function fnLoadGridData(pmyGrid1,pageNumber){  //数据库中分页取数据
			var myGrid1=pmyGrid1.id;
			var pager =$("#myGrid1").datagrid('getPager');
			pager.pagination('refresh',{	//改变选项，并刷新分页栏信息
				pageNumber: pageNumber
			});
			var pageSize=opts.pageSize;
			$.ajax({     
				type: "Post",     
				url: "system/easyui_getGridData.jsp",     
				data: {
					database: sysdatabasestring, 
					selectsql: pmyGrid1.activesql,
					keyfield: pmyGrid1.keyfield,
					sortfield: '',
					limit: pageSize,
					start: (pageNumber-1)*pageSize,
					summaryfields:''				
				}, 
				async: false, method: 'post',    
				success: function(data) {   
					eval("var source="+data+";");
					$('#myGrid1').datagrid( "loadData", source );  //必须用loaddata
					//根据总行数改变行号的列宽度，改css
					var rowcount=$("#myGrid1").datagrid('getData').total+'';  //转换为字符型
					var width=(rowcount.length*6+8);
					if (width<25) width=25;
					var px=width+'px';
					$('.datagrid-header-rownumber,.datagrid-cell-rownumber').css({"width": px});
					$('#myGrid1').datagrid('resize');  //必须写
					$('#myGrid1').datagrid('selectRow',0); //选中某行
				}    
			});
		}
    });
    
    function fncheck(){
    
        var sqlx="insert into mybooks (id,name,parentnodeid,isparentflag,ancester,level) values(";
    		  sqlx+="'"+$("#id").textbox('getValue')+"',";
    		  sqlx+="'"+$("#name").textbox('getValue')+"',";
    		  sqlx+="'',";
    		  sqlx+="'1',";
    		  sqlx+="'',";
    		  sqlx+="'1'";
    		  sqlx+=")";
    		 var result=myRunUpdateSql(sysdatabasestring,sqlx);   
    
        var sql="update mystudents set checkout='已审核' where stuid='"+$("#id").textbox('getValue')+"'";
        var result=myRunUpdateSql(sysdatabasestring,sql);
        alert('审核完成');
        
        

        }
    function fnEdit(){
    	mySetFormReadonly(false);
    	$("#name").next("span").find("input").focus();
    	fnsave();
    	
    }
    function fnSave(){
       var sql="update mystudents set ";
    	   sql+="stuname='"+$("#name").textbox('getValue')+"',";
    		sql+="gender='"+$("#gender").textbox('getValue')+"',";
    		sql+="classid='"+$("#classid").textbox('getValue')+"',";
    		sql+="phone='"+$("#phone").textbox('getValue')+"'";
    		sql+=" where stuid='"+$("#id").textbox('getValue')+"'";
    	var result=myRunUpdateSql(sysdatabasestring,sql);
    	alert('已保存！');
    	
    }
    function fnDelete(){  //删除记录
    	var keyvalue=$("#id").textbox("getValue");
    	$.messager.confirm('系统提示','删除学生'+keyvalue+"<br>是否确定？",function(r){
			if (r){
				var sql="delete mystudents where stuid='"+keyvalue+"'";	
    			var result=myRunUpdateSql(sysdatabasestring,sql);
    			if (result.error==''){
    				fnRefresh();
    			}else{
    				console.log(result.error);
    			}
    		}	
		});
    }
    function fnRefresh(){
	    var pmyGrid1={};
		pmyGrid1.id='myGrid1';
		pmyGrid1.parent='left';
		pmyGrid1.staticsql="select stuid,stuname,gender,classid,phone,checkout from mystudents";
		pmyGrid1.activesql=pmyGrid1.staticsql;
		pmyGrid1.gridfields='[@c%c#110,2]姓名/stuname;[@c%c#110,3]性别/gender;[@l%c#110,4]班级编号/classid;';
		pmyGrid1.gridfields+='[@l%c#110,5]联系方式/phone;[@c%c#110,6]审核状态/checkout';
		pmyGrid1.fixedfields='[@l%c#90]学号/stuid';
		pmyGrid1.title='学生信息';
		pmyGrid1.menu='myMenu1';
		pmyGrid1.checkbox='single';
		pmyGrid1.pagesize=10;
		pmyGrid1.keyfield='stuid';
		pmyGrid1.rownumbers=true;
		pmyGrid1.collapsible=true;
		pmyGrid1.height=400;
		pmyGrid1.width=700;
		pmyGrid1.rowindex=0;
		pmyGrid1.columns=[];
		//定义grid
		myGrid(pmyGrid1);

		myLoadGridData(pmyGrid1,1);
		
		mySetFormReadonly(true);
	    
	}
    
</script>
</body>
</html>
