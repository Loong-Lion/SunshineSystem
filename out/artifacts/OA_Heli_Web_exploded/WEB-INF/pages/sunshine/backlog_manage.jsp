<%--
  Created by IntelliJ IDEA.
  User: Loong
  Date: 2019/1/13
  Time: 19:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="com.heli.oa.common.entity.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    User u =(User)session.getAttribute("user");
%>
<html>
<head>
    <title>待办事项</title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <link rel="stylesheet" href="<%=basePath%>static/layui/css/layui.css" media="all">
    <script src="http://libs.baidu.com/jquery/2.0.0/jquery.min.js"></script>
    <script src="https://cdn.bootcss.com/jsencrypt/3.0.0-beta.1/jsencrypt.js"></script>
    <script src="<%=basePath%>static/layui/layui.js"></script>
    <script src="<%=basePath%>static/js/base64.js"></script>
    <style type="text/css">


        .tb {
            margin-left: 31px;
        }

        #toolsBtn {
            margin-top: 15px;
        }

        .double {
            width: 600px;
            float: left;
        }

        .zhengti {
            overflow: hidden;
        }

        .zuo {
            width: 600px;
            height: 782px;
            border: 1px solid silver;
            float: left;

        }

        .backlogDiv1 {
            width: 500px;
            height: 390px;
            border: 1px solid silver;
            float: left;
        }

        .backlogDiv2 {
            width: 500px;
            height: 390px;
            border: 1px solid silver;
            float: left;
        }

        .backlogDiv3 {
            width: 500px;
            height: 390px;
            border: 1px solid silver;
            float: left;
        }

        .backlogDiv4 {
            width: 500px;
            height: 390px;
            border: 1px solid silver;
            float: left;
        }

        .ok {
            color: #00F7DE;
            border-bottom: #00F7DE;
            float: right;
        }

        .quanbu {
            width: 1000px;
            height: 1800px;
            overflow: hidden;
        }
        #newTaskForm .layui-form .layui-form-label{
            width: 150px;
        }
        /*.layui-inline{margin-top:36px;}*/
    </style>
</head>
<body style="background-color: white;">
<div class="layui-tab layui-tab-brief" lay-filter="docDemoTabBrief">
    <ul class="layui-tab-title">
        <li onclick="updateBacklog();">个人待办事项</li>
        <li onclick="updateDoneBacklog();">已完成事项</li>
    </ul>
    <div class="layui-tab-content" style="height: 100px;">
        <div class="layui-tab-item ">
            <div class="zhengti">
                <div class="zuo">
                    <button class="layui-btn layui-btn-normal addBacklog" style="margin: 20px">添加待办事宜</button>
                    <table class="layui-table" id="toadyBacklogTable" lay-filter="toadyBacklogTable"></table>
                </div>
                <div class="backlogDiv1">
                    <h3 style="margin: 10px">重要紧急</h3>
                    <table class="layui-table" id="backlogTable1" lay-filter="backlogTable"></table>
                </div>
                <div class="backlogDiv2">
                    <h3 style="margin: 10px">重要不紧急</h3>
                    <table class="layui-table" id="backlogTable2" lay-filter="backlogTable"></table>
                </div>
                <br>
                <div class="backlogDiv3">
                    <h3 style="margin: 10px">紧急不重要</h3>
                    <table class="layui-table" id="backlogTable3" lay-filter="backlogTable"></table>
                </div>
                <div class="backlogDiv4">
                    <h3 style="margin: 10px">不重要不紧急</h3>
                    <table class="layui-table" id="backlogTable4" lay-filter="backlogTable"></table>
                </div>
            </div>
        </div>

        <div class="layui-tab-item">
            <form class="layui-inline layui-form">
                <div class="layui-form-item">

                    <label class="layui-form-label" >创建时间：</label>
                    <div class="layui-input-inline" style="width: 320px">
                        <input type="text" name="createTimeForSearch" id="createTimeForSearch" lay-verify="required"
                               placeholder="yyyy-MM-dd HH:mm:ss-yyyy-MM-dd HH:mm:ss" autocomplete="off" class="layui-input" >
                    </div>
                    <label class="layui-form-label" >完成时间：</label>
                    <div class="layui-input-inline" style="width: 320px">
                        <input type="text" name="doneTimeForSearch" id="doneTimeForSearch" lay-verify="required"
                               placeholder="yyyy-MM-dd HH:mm:ss-yyyy-MM-dd HH:mm:ss" autocomplete="off" class="layui-input" >
                    </div>

                    <label class="layui-form-label" >时间安排：</label>
                    <div class="layui-input-inline" style="width: 80px">
                        <input type="text" name="startTimeStr" id="startTimeStr" lay-verify="required" placeholder="HH:mm" autocomplete="off"
                               class="layui-input">
                    </div>
                    <div class="layui-input-inline" style="width: 30px;line-height: 35px;">
                        ——
                    </div>
                    <div class="layui-input-inline" style="width: 80px">
                        <input type="text" name="endTimeStr" id="endTimeStr" lay-verify="required" placeholder="HH:mm" autocomplete="off" class="layui-input">
                    </div>

                    <label class="layui-form-label" style="width: 100px;" >重要紧急程度：</label>
                    <div class="layui-input-inline">
                        <select name="priority" lay-search="" id="priority">
                            <option value="">全部事宜</option>
                            <option value="重要紧急">重要紧急</option>
                            <option value="重要不紧急">重要不紧急</option>
                            <option value="不重要紧急">不重要紧急</option>
                            <option value="不重要不紧急">不重要不紧急</option>
                        </select>
                    </div>
                    <button class="layui-btn layui-btn-sm" lay-submit="" lay-filter="search">搜索</button>
                </div>
            </form>
            <div class="kuan" style="width: 95%;height: 90%;margin-left: 30px;">
                <table class="layui-table" id="doneBacklogTable"></table>
            </div>
        </div>
    </div>

    <div id="detailsTableDiv" class="layui-tab-content" style="height: 100px;">
        <div class="layui-tab-item">
            <div style="width: 95%;height: 90%;margin-left: 30px;">
                <table id="detailsTable" lay-filter="createTable" lay-skin="nob"></table>
            </div>
        </div>
    </div>
</div>
<form id="addBacklogDiv" class="layui-form" style="display:none;">
    <div class="layui-form-item">
        <label class="layui-form-label">重要程度:</label>
        <div class="layui-input-block">
            <input type="radio" name="important" value="重要" title="重要" id="important">
            <input type="radio" name="important" value="不重要" title="不重要" id="unimportant" >
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">紧急程度:</label>
        <div class="layui-input-block">
            <input type="radio" name="urgent" value="紧急" title="紧急" id="urgent">
            <input type="radio" name="urgent" value="不紧急" title="不紧急" id="noturgent" >
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">事宜内容:</label>
        <div class="layui-input-block">
                    <textarea id="backlogContent" lay-verify="required" placeholder="请输入内容" rows="3"
                              cols="20" class="layui-textarea" style="width: 300px"></textarea>
        </div>
    </div>
</form>

<form id="setBacklogTime" class="layui-form" style="display: none;">
    <br><br>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label" style="width: 100px;">开始时间：</label>
            <div class="layui-input-inline">
                <input type="text" class="layui-input" id="startTime" placeholder="HH:mm">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label" style="width: 100px;">结束时间：</label>
            <div class="layui-input-inline">
                <input type="text" class="layui-input" id="endTime" placeholder="HH:mm">
            </div>
        </div>
    </div>
</form>
<form id="refuseTaskReport" class="layui-form" style="display: none;">
    <br><br>
    <div class="layui-form-item">
        <label class="layui-form-label">拒绝任务原因:</label>
        <div class="layui-input-block" style="width: 230px;">
            <textarea id="comment"  lay-verify="required" placeholder="请输入拒绝任务原因" class="layui-textarea"></textarea>
        </div>
    </div>
</form>

    <script type="text/html" id="bar4">
        <a class="layui-btn layui-btn-xs setTime" lay-event="setTime">定时</a>
        <a class="layui-btn layui-btn-xs" lay-event="over">完成</a>
        <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete">删除</a>
    </script>
    <script type="text/html" id="bar5">
        <button class="layui-btn layui-btn-xs" lay-event="over">完成</button>
        <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="cancel">撤销</button>
    </script>
    <script type="text/html" id="bar7">
        <button class="layui-btn layui-btn-xs" lay-event="accept">接受</button>
        <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="refuse">拒绝</button>
    </script>
</body>
    <script type="text/javascript">
        var table = null;
        var form = null;
        layui.use(['table', 'form', 'layer', 'laydate'], function () {
            table = layui.table;
            form = layui.form;
            var laydate = layui.laydate;
            var layer = layui.layer;

            //格式化日期时间为yyyy-MM-dd HH:mm:ss
            function timeStamp2String(time) {
                var datetime = new Date();
                datetime.setTime(time);
                var year = datetime.getFullYear();
                var month = datetime.getMonth() + 1 < 10 ? "0" + (datetime.getMonth() + 1) : datetime.getMonth() + 1;
                var date = datetime.getDate() < 10 ? "0" + datetime.getDate() : datetime.getDate();
                var hour = datetime.getHours() < 10 ? "0" + datetime.getHours() : datetime.getHours();
                var minute = datetime.getMinutes() < 10 ? "0" + datetime.getMinutes() : datetime.getMinutes();
                var second = datetime.getSeconds() < 10 ? "0" + datetime.getSeconds() : datetime.getSeconds();
                return year + "-" + month + "-" + date + " " + hour + ":" + minute + ":" + second;
            }

            //HH:mm
            function timeStamp2HourMinutesStr(time) {
                var datetime = new Date();
                datetime.setTime(time);
                var hour = datetime.getHours() < 10 ? "0" + datetime.getHours() : datetime.getHours();
                var minute = datetime.getMinutes() < 10 ? "0" + datetime.getMinutes() : datetime.getMinutes();
                var second = datetime.getSeconds() < 10 ? "0" + datetime.getSeconds() : datetime.getSeconds();
                return hour + ":" + minute + ":" + second;
            }

            laydate.render({
                elem: '#limitTaskDateTime',
                type: 'datetime',
                min: timeStamp2String(new Date().getTime())
            });
            laydate.render({ //发布时间
                elem: '#date'
            });
            laydate.render({
                elem: '#repeatTaskTimeInput'
                , type: 'time'
            });

            date = new Date();
            laydate.render({
                elem: '#createTimeForSearch'
                ,format: 'yyyy-MM-dd HH:mm:ss' //可任意组合
                ,type: 'datetime'
                ,min: '2018-12-7 00:00:00'
                ,max:'date'
                ,range: true
            });

            laydate.render({
                elem: '#doneTimeForSearch'
                ,format: 'yyyy-MM-dd HH:mm:ss' //可任意组合
                ,type: 'datetime'
                ,min: '2018-12-7 00:00:00'
                ,max: 'date'
                ,range: true
            });

            laydate.render({
                elem: '#startTimeStr'
                ,format: 'HH:mm:ss'
                ,type: 'time'
            });

            laydate.render({
                elem: '#endTimeStr'
                ,format: 'HH:mm'
                ,type: 'time'

            });

            //根据任务类型，显示隐藏对应div
            var taskType = '单次任务';
            form.on('radio(taskType)', function (data) {
                taskType = data.elem.title;
                switch (parseInt(data.value)) {
                    case 1 :
                        $("#limitTaskDateTimeDiv").hide();
                        $("#repeatCreatTimeDiv").hide();
                        $("#repeatTaskLimitTimeDiv").hide();
                        $("#repeatTaskRemindTimeDiv").hide();
                        $("#repeatTaskEndTimeDiv").hide();
                        $("#limitTaskDateTime").removeAttr("lay-verify");
                        $("#repeatTaskTimeInput").removeAttr("lay-verify");
                        $("#day").removeAttr("lay-verify");
                        $("#hour").removeAttr("lay-verify");
                        $("#repeatTaskEndTimeInput").removeAttr("lay-verify");
                        break;
                    case 2 :
                        $("#limitTaskDateTimeDiv").hide();
                        $("#repeatCreatTimeDiv").show();
                        $("#repeatTaskRemindTimeDiv").show();
                        $("#repeatTaskLimitTimeDiv").show();
                        $("#repeatTaskEndTimeDiv").show();
                        $("#repeatTaskTimeInput").attr("lay-verify", "required");
                        $("#day").attr("lay-verify", "required");
                        $("#hour").attr("lay-verify", "required");
                        $("#repeatTaskEndTimeInput").attr("lay-verify", "required");
                        $("#limitTaskDateTime").removeAttr("lay-verify");
                        break;
                    case 3 :
                        $("#limitTaskDateTimeDiv").show();
                        $("#repeatTaskRemindTimeDiv").show();
                        $("#repeatCreatTimeDiv").hide();
                        $("#repeatTaskLimitTimeDiv").hide();
                        $("#repeatTaskEndTimeDiv").hide();
                        $("#limitTaskDateTime").attr("lay-verify", "required");
                        $("#repeatTaskTimeInput").removeAttr("lay-verify");
                        $("#day").removeAttr("lay-verify");
                        $("#hour").removeAttr("lay-verify");
                        $("#repeatTaskEndTimeInput").removeAttr("lay-verify");
                        break;
                }
            });

            //监听重复方式复选框，根据重复方式，显示或隐藏对应div
            form.on('select(repeatWay)', function (data) {
                //laydate.render()未生效，先removeinput，再加入
                $("#repeatTaskEndTimeInput").remove();
                $("#setNewDate").html("<input type=\"text\" class=\"layui-input\" id=\"repeatTaskEndTimeInput\" name =\"repeatTaskEndTimeInput\" autocomplete=\"off\"  placeholder=\"yyyy-MM-dd\" >");
                switch (parseInt(data.value)) {
                    //周
                    case 1 :
                        $("#selectWeekdayDiv").show();
                        $("#selectDayDiv").hide();
                        $("#repeatTaskTimeDiv").show();
                        $("#limitTaskDateTime").removeAttr("lay-verify");
                        laydate.render({
                            elem: '#repeatTaskEndTimeInput',
                            type: 'datetime',
                            min: timeStamp2String(new Date().getTime() + 604800000)
                        });
                        break;
                    //月
                    case 2 :
                        $("#selectWeekdayDiv").hide();
                        $("#selectDayDiv").show();
                        $("#repeatTaskTimeDiv").show();
                        $("#limitTaskDateTime").removeAttr("lay-verify");
                        laydate.render({
                            elem: '#repeatTaskEndTimeInput',
                            type: 'datetime',
                            min: timeStamp2String(new Date().getTime() + 2419200000)
                        });
                        break;
                    //天
                    case 3 :
                        $("#selectWeekdayDiv").hide();
                        $("#selectDayDiv").hide();
                        $("#repeatTaskTimeDiv").show();
                        $("#limitTaskDateTime").removeAttr("lay-verify");
                        laydate.render({
                            elem: '#repeatTaskEndTimeInput',
                            type: 'datetime',
                            min: timeStamp2String(new Date().getTime() + 86400000)
                        });
                        break;
                    case 4 :
                        $("#selectWeekdayDiv").hide();
                        $("#selectDayDiv").hide();
                        $("#repeatTaskTimeDiv").hide();
                        $("#limitTaskDateTime").removeAttr("lay-verify");
                }
            });

            //新建任务提交监听
            form.on('submit(createTask)', function (data) {
                //防止按钮二次触发
                $("#createTask").addClass("layui-btn-disabled");

                var obj = data.field;
                console.log($("#limitTaskDateTime"));
                if ((obj.repeatWay == "4") && (taskType == "重复任务")) {
                    layer.msg("任务发布失败，请选择重复方式");
                    return false;
                }

                var oCks = xtree.GetChecked(); //获取人员管理数中选中的所有的人员
                var receiver = '';
                //未选任务接收人，默认为当前用户自己
                if (oCks.length > 0) {
                    for (var i = 0; i < oCks.length; i++) {
                        receiver = receiver + oCks[i].value + ',';
                    }
                    receiver = receiver.substr(0, receiver.length - 1);
                } else {
                    receiver = '<%=u.getUserNickname()%>';
                }

                //拼接成字符串，后台解析成数组
                var taskRepeatWay = obj.repeatWay + ',' + obj.selectWeekday + ',' + obj.selectDay + ',' + $("#repeatTaskTimeInput").val();
                //换算成毫秒
                var day = $("#day").val();
                var hour = $("#hour").val();
                var time1 = day * 86400000 + hour * 3600000;
                var remindHour = $("#remindHour").val();

                $.ajax({
                    url: '<%=basePath%>task_add.action',
                    type: 'post',
                    async: false,
                    data: {
                        taskType: taskType,
                        title: obj.taskTitle,
                        creater: '<%=u.getUserNickname()%>',
                        receiver: receiver,
                        content: obj.content,
                        taskLimitTime: obj.limitTaskDateTime,
                        repeatTaskEndTime: obj.repeatTaskEndTimeInput,
                        taskRepeatWay: taskRepeatWay,
                        repeatTaskLimitTime: time1,
                        remindHour:remindHour
                    },
                    beforeSend: function () {
                        layer.msg('任务发布中，请稍等。。。');
                    },
                    success: function (data) {       //suceess是ajax回调，返回的是data ，data即code对象，code包含数组集合，分页集合等内容
                        if (data.code == 200) {
                            layer.msg("任务发布成功，已通知相关人员");
                            document.getElementById("newTaskForm").reset();
                            taskType = "单次任务";
                            updateCreate();
                            updateDoing();
                            $("#limitTaskDateTimeDiv").hide();
                            $("#repeatCreatTimeDiv").hide();
                            $("#repeatTaskLimitTimeDiv").hide();
                            $("#repeatTaskEndTimeDiv").hide();
                            $("#createTask").removeClass("layui-btn-disabled");

                        }
                    }
                });
            });

            //待接受表格工具列监听
            table.on('tool(acceptTable)', function(obj){ //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
                var data = obj.data; //获得当前行数据
                var layEvent = obj.event;

                if(layEvent === 'accept'){ //通过审核
                    layer.confirm('确定接受任务？', function(index){
                        layer.close(index);
                        $.ajax({
                            url: '<%=basePath%>task_acceptOrRefuse.action',
                            type: 'post',
                            data: {'recordId': data.recordId,
                                'taskStatus': "已接受"},
                            success: function () {updateAccept();}
                        })
                    });

                } else if(layEvent === 'refuse'){ //审核不通过，修改任务状态为未完成，并添加不合格原因
                    layer.open({
                        type:1 ,
                        content:$("#refuseTaskReport"), //'是否确定删除此条部门记录'
                        area: ['400px', '300px'],  //指定弹出层尺寸
                        btn:["确定","取消"],
                        btnAlign: 'c',
                        closeBtn: 0,
                        btn1:function () {
                            var comment = $("#comment").val();
                            $.ajax({
                                url: '<%=basePath%>task_acceptOrRefuse.action',
                                type: 'post',
                                data: {'recordId': data.recordId,
                                    'taskStatus': "已拒绝",
                                    "refuseComment":comment
                                },
                                success: function (data) {       //suceess是ajax回调，返回的是data ，data即code对象，code包含数组集合，分页集合等内容
                                    if (data.code == 200) {
                                        //empty方法不管用
                                        document.getElementById("refuseTaskReport").reset();
                                        $("#refuseTaskReport").css("display","none");
                                        updateAccept();
                                        layer.close(layer.index)  //关闭ID窗口
                                    }
                                }
                            })
                        },
                        btn2:function () {
                            document.getElementById("refuseTaskReport").reset();
                            $("#refuseTaskReport").css("display","none");
                            layer.close(layer.index)
                        },
                    });
                }
            });

            //进行中任务工具栏按钮
            table.on('tool(doingTable)', function (obj) {
                var data = obj.data;
                var html1 = "<form id=\"taskReport\" class=\"layui-form\" " +
                    "    <br>\n" +
                    "    <div class=\"layui-form-item\" id=\"taskReport1\">\n" +
                    "        <label class=\"layui-form-label\">任务报告:</label>\n" +
                    "        <div class=\"layui-input-block\" style=\"width: 230px;\">\n" +
                    "            <textarea id=\"report\"  lay-verify=\"required\" placeholder=\"请输入任务报告\" class=\"layui-textarea\"></textarea>\n" +
                    "        </div>\n" +
                    "    </div>\n" +
                    "</form>"
                if (obj.event === 'over') {
                    layer.open({
                        type: 1,
                        content: html1, //'是否确定删除此条部门记录'
                        area: ['400px', '250px'],  //指定弹出层尺寸
                        btn: ["提交", "取消"],
                        btnAlign: 'c',
                        btn1: function () {
                            var report = $("#report").val();
                            $.ajax({
                                url: '<%=basePath%>task_report.action',
                                type: 'post',
                                data: {
                                    "recordId": data.recordId
                                    , 'report': report
                                },
                                success: function (data) {       //suceess是ajax回调，返回的是data ，data即code对象，code包含数组集合，分页集合等内容
                                    if (data.code == 200) {
                                        layer.close(layer.index);  //关闭ID窗口
                                        layer.msg("任务报告提交成功");
                                        updateDoing();
                                        updateDone();
                                        updateCreate();
                                    }
                                }
                            })
                        },
                        btn2: function () {
                            document.getElementById("report").reset();
                            layer.close(layer.index)
                        }
                    });
                }

            });

            //取消任务工具栏按钮
            table.on('tool(createTable)', function (obj) {
                var data = obj.data;
                if (obj.event === 'details') {

                    layer.open({
                        type: 2,
                        content: '<%=basePath%>page/admin/task_details.jsp?taskId=' + data.taskId, //'是否确定删除此条部门记录'
                        area: ['1700px', '600px'],  //指定弹出层尺寸
                        btn: ["确定"],
                        btnAlign: 'c',
                        data: data,
                        btn1: function () {
                            layer.close(layer.index);
                        },
                    });
                } else if (obj.event === 'cancel') {
                    layer.open({
                        type: 1,
                        content: '是否确定取消此任务', //'是否确定删除此条部门记录'
                        area: ['400px', '250px'],  //指定弹出层尺寸
                        btn: ["确定", "取消"],
                        btnAlign: 'c',
                        btn1: function () {
                            $.ajax({
                                url: '<%=basePath%>task_cancelFather.action',
                                type: 'post',
                                data: data
                                /*{
                                    taskId : data.taskId,
                                }*/,
                                success: function (data) {       //suceess是ajax回调，返回的是data ，data即code对象，code包含数组集合，分页集合等内容
                                    if (data.code == 200) {
                                        layer.close(layer.index);  //关闭ID窗口
                                        layer.msg("任务已取消");
                                        updateCreate();
                                        updateDoing();
                                    }
                                }
                            })
                        },
                        btn2: function () {
                            layer.close(layer.index)
                        }
                    });
                }
            });

            //新建待办事宜弹出
            $(".addBacklog").click(function(){
                $("#addBacklogDiv input[name=urgent]")[0].checked = true;
                $("#addBacklogDiv input[name=important]")[0].checked = true;
                form.render();
                layer.open({
                    type:1 ,
                    title: '新建待办事宜',
                    area :['450px','350px'],
                    content:$("#addBacklogDiv"),
                    btn:["提交","取消"],
                    btnAlign: 'c',
                    btn1:function () {
                        var important = null;
                        var urgent = null;
                        if($("#addBacklogDiv input[name=important]")[0].checked == true){
                            important = "重要"}else{
                            important = "不重要"
                        }
                        if($("#addBacklogDiv input[name=urgent]")[0].checked == true){
                            urgent = "紧急"}else{
                            urgent = "不紧急"
                        }

                        var priority = important + urgent ;
                        var content = $("#backlogContent").val();
                        $.ajax({
                            url: '<%=basePath%>backlog_add.action',
                            type: 'post',
                            data: {
                                "priority": priority,
                                "content": content,
                                "userId":<%=u.getUserId()%>
                            },
                            success: function (data) {
                                if (data.code == 200) {
                                    document.getElementById("addBacklogDiv").reset();
                                    $("#addBacklogDiv").css("display","none");
                                    updateBacklogNotSetTime();
                                    layer.close(layer.index)  //关闭弹出来的窗口

                                }
                            }
                        })
                    },
                    btn2:function(){
                        document.getElementById("addBacklogDiv").reset();
                        $("#addBacklogDiv").css("display","none");
                    },
                    cancel:function () {
                        document.getElementById("addBacklogDiv").reset();
                        $("#addBacklogDiv").css("display","none");
                    }
                });
                form.render();
            });

            //监听待办事项四象限按钮
            table.on('tool(backlogTable)', function (obj) {
                var data = obj.data;
                if (obj.event === 'setTime') {

                    laydate.render({
                        elem: '#startTime'
                        ,format: 'HH:mm'
                        ,min: timeStamp2HourMinutesStr(new Date().getTime() + 120*1000)
                        ,type: 'time'
                    });

                    laydate.render({
                        elem: '#endTime'
                        ,format: 'HH:mm' //可任意组合
                        ,min: timeStamp2HourMinutesStr(new Date().getTime() + 120*1000)
                        ,type: 'time'
                    });

                    layer.open({
                        type:1,
                        title: '定时',
                        area :['350px','250px'],
                        content: $("#setBacklogTime"),
                        btn:["确定","取消"],
                        btnAlign: 'c',
                        async: false,
                        btn1:function () {
                            var startTime = $("#startTime").val();
                            var endTime = $("#endTime").val();

                            if(startTime>=endTime){
                                layer.msg("开始时间不能大于结束时间，请重新填写。");
                                document.getElementById("setBacklogTime").reset();
                                return;
                            }

                            $.ajax({
                                url: '<%=basePath%>backlog_setTime.action',
                                type: 'post',
                                async: false,
                                data: {
                                    "recordId":data.recordId,
                                    "startTimeStr": startTime,
                                    "endTimeStr": endTime,
                                },
                                success: function (data1) {
                                    if (data1.code == 200) {
                                        document.getElementById("setBacklogTime").reset();
                                        $("#setBacklogTime").css("display","none");
                                        updateBacklog();
                                        layer.close(layer.index)  //关闭弹出来的窗口
                                    }else if(data1.code == 500){
                                        var userId = <%=u.getUserId()%>;
                                        insertBacklog(userId,data.recordId,startTime,endTime);
                                        document.getElementById("setBacklogTime").reset();
                                        $("#setBacklogTime").css("display","none");
                                    }
                                }
                            })
                        },
                        btn2:function(){
                            document.getElementById("setBacklogTime").reset();
                            $("#setBacklogTime").css("display","none");
                        },
                        cancel:function () {
                            document.getElementById("setBacklogTime").reset();
                            $("#setBacklogTime").css("display","none");
                        }
                    });
                } else if (obj.event === 'over') {
                    layer.open({
                        type: 1,
                        content: '是否确定完成此待办事项', //'是否确定删除此条部门记录'
                        area: ['400px', '250px'],  //指定弹出层尺寸
                        btn: ["确定", "取消"],
                        btnAlign: 'c',
                        btn1: function () {
                            $.ajax({
                                url: '<%=basePath%>backlog_over.action',
                                type: 'post',
                                data: data
                                /*{
                                    taskId : data.taskId,
                                }*/,
                                success: function (data) {       //suceess是ajax回调，返回的是data ，data即code对象，code包含数组集合，分页集合等内容
                                    if (data.code == 200) {
                                        layer.close(layer.index);  //关闭ID窗口
                                        layer.msg("待办事项已完成");
                                        updateBacklogNotSetTime();
                                    }
                                }
                            })
                        },
                        btn2: function () {
                            layer.close(layer.index)
                        }
                    });
                } else if (obj.event === 'delete') {
                    layer.open({
                        type: 1,
                        content: '是否确定删除此待办事项', //'是否确定删除此条部门记录'
                        area: ['400px', '250px'],  //指定弹出层尺寸
                        btn: ["确定", "取消"],
                        btnAlign: 'c',
                        btn1: function () {
                            $.ajax({
                                url: '<%=basePath%>backlog_delete.action',
                                type: 'post',
                                data: data,
                                success: function (data) {
                                    if (data.code == 200) {
                                        layer.close(layer.index);
                                        layer.msg("待办事项已删除");
                                        updateBacklogNotSetTime();
                                    }
                                }
                            })
                        },
                        btn2: function () {
                            layer.close(layer.index)
                        }
                    });
                }
            });

            //监听待办事项今日已定时表
            table.on('tool(toadyBacklogTable)', function (obj) {
                var data = obj.data;
                if (obj.event === 'over') {
                    layer.open({
                        type: 1,
                        content: '是否确定完成此待办事项', //'是否确定删除此条部门记录'
                        area: ['400px', '250px'],  //指定弹出层尺寸
                        btn: ["确定", "取消"],
                        btnAlign: 'c',
                        btn1: function () {
                            $.ajax({
                                url: '<%=basePath%>backlog_over.action',
                                type: 'post',
                                data: data
                                /*{
                                    taskId : data.taskId,
                                }*/,
                                success: function (data) {       //suceess是ajax回调，返回的是data ，data即code对象，code包含数组集合，分页集合等内容
                                    if (data.code == 200) {
                                        layer.close(layer.index);  //关闭ID窗口
                                        layer.msg("待办事项已完成");
                                        updateTodayBacklog();
                                    }
                                }
                            })
                        },
                        btn2: function () {
                            layer.close(layer.index)
                        }
                    });
                } else if (obj.event === 'cancel') {
                    layer.open({
                        type: 1,
                        content: '是否确定撤销此待办事项定时', //'是否确定删除此条部门记录'
                        area: ['400px', '250px'],  //指定弹出层尺寸
                        btn: ["确定", "取消"],
                        btnAlign: 'c',
                        btn1: function () {
                            $.ajax({
                                url: '<%=basePath%>backlog_cancelTime.action',
                                type: 'post',
                                data: data,
                                success: function (data) {
                                    if (data.code == 200) {
                                        layer.close(layer.index);
                                        layer.msg("待办事项已取消定时");
                                        updateBacklog();
                                    }
                                }
                            })
                        },
                        btn2: function () {
                            layer.close(layer.index)
                        }
                    });
                }
            });

            //监听已完成待办事项的搜索提交
            form.on('submit(search)', function(data){
                var obj = data.field;
                if(obj.startTimeStr >= obj.endTimeStr) {
                    layer.msg("时间安排：开始时间不能大于结束时间，请重新填写。");
                    return;
                }
                obj.userId = <%=u.getUserId()%>;
                $.ajax({
                    url: '<%=basePath%>backlog_searchDone.action',
                    type: 'post',
                    async: false,
                    data: obj,
                    success: function (data1) {
                        if (data1.code == 200) {

                            table.render({
                                elem: '#doneBacklogTable',
                                data: data1.paramList,
                                cols: [[
                                    {field: 'doneTime', title: '创建时间', align: "center", width: 180}
                                    ,{field: 'doneTime', title: '完成时间', align: "center", width: 180}
                                    ,{field: 'timeSlot', title: '时间安排', align: "center", width: 117}
                                    ,{field: 'priority', title: '重要紧急程度', align: "center", width: 120}
                                    ,{field: 'content', title: '内容', align: "center"}
                                ]]
                            })

                        }
                    }
                });
                return false;
            });

            form.render();
        });

        //创建任务页面，待选员工读取，用了layui第三方框架 Xtree
        var users = null;
        $.ajax({
            url: '<%=basePath%>user_listAllByDep.action',
            type: 'post',
            async: false,
            success: function (data) {       //suceess是ajax回调，返回的是data ，data即code对象，code包含数组集合，分页集合等内容
                if (data.code == 200) {
                    users = data.paramObject;
                }
            }
        });
        var json3 = null;
        var json4 = '';
        for (var key in users) {
            var json1 = '';
            for (var i = 0; i < users[key].length; i++) {
                var json2 = '{ "title": "' + users[key][i].userNickName + '", "value": "' + users[key][i].userNickName + '", "data": [] },'
                json1 = json1 + json2;
            };
            json1 = json1.substr(0, json1.length - 1);
            json3 = '{"title":"' + key + '", "value": "' + key + '", "data": [' + json1 + ' ]},';
            json4 = json4 + json3;
        }
        json4 = JSON.parse('[' + json4.substr(0, json4.length - 1) + ']');

        var xtree = new layuiXtree({
            elem: 'userTree'   //(必填) 放置xtree的容器id，不要带#号
            , form: form     //(必填) layui 的 from
            , data: json4    //(必填) json数组（数据格式在下面）
            , isopen: false
            , icon: {        //三种图标样式，更改几个都可以，用的是layui的图标
                end: "&#xe6af;"      //末尾节点的图标
            }
        });

        //刷新待接收任务
        function updateAccept() {
            $.ajax({
                url: '<%=basePath%>task_listAcceptByReceiver.action',
                type: 'post',
                data: {"receiver": '<%=u.getUserNickname()%>'},
                success: function (data) {
                    if (data.code == 200) {
                        table.render({
                            elem: '#acceptTable', //指定原始表格元素选择器
                            data: data.paramList,     //相当于code.paramlist
                            page: { //支持传入 laypage 组件的所有参数（某些参数除外，如：jump/elem） - 详见文档
                                layout: ['limit', 'count', 'prev', 'page', 'next', 'skip'] //自定义分页布局
                                , count: 100
                                , curr: 1 //设定初始在第 5 页
                                , groups: 3 //只显示 1 个连续页码
                                , first: false //不显示首页
                                , last: false //不显示尾页
                            },
                            cols: [[ //表头
                                {field: 'recordId', title: '任务ID',width:75,align:'center'}
                                ,{field: 'creater', title: '创建者',width:75,align:'center'}
                                ,{field: 'receiver', title: '接收人',width:75,align:'center'}
                                ,{field: 'createTime', title: '创建时间',width:165,align:'center'}
                                ,{field: 'title', title: '标题',width:200,align:'center'}
                                ,{field: 'taskLimitTime', title: '完成期限',width:165,align:'center'}
                                ,{field: 'taskType', title: '任务类型',width:90,align:'center'}
                                ,{field: 'taskStatus', title: '任务状态',width:90,align:'center'}
                                ,{field: 'content', title: '内容',width:400,align:'center'}
                                ,{title: '操作',toolbar: '#bar7', width:150,align:'center'}
                            ]]
                        })
                    }
                }
            })
        }

        //刷新进行中任务
        function updateDoing() {
            $.ajax({
                url: '<%=basePath%>task_listDoingByReceiver.action',
                type: 'post',
                data: {"receiver": '<%=u.getUserNickname()%>'},
                success: function (data) {
                    if (data.code == 200) {
                        table.render({
                            elem: '#doingTable', //指定原始表格元素选择器
                            data: data.paramList,     //相当于code.paramlist
                            page: { //支持传入 laypage 组件的所有参数（某些参数除外，如：jump/elem） - 详见文档
                                layout: ['limit', 'count', 'prev', 'page', 'next', 'skip'] //自定义分页布局
                                , count: 100
                                , curr: 1 //设定初始在第 5 页
                                , groups: 3 //只显示 1 个连续页码
                                , first: false //不显示首页
                                , last: false //不显示尾页
                            },
                            cols: [[ //表头
                                {field: 'recordId', title: '任务ID',width:75,align:'center'}
                                ,{field: 'creater', title: '创建者',width:75,align:'center'}
                                ,{field: 'receiver', title: '接收人',width:75,align:'center'}
                                ,{field: 'createTime', title: '创建时间',width:165,align:'center'}
                                ,{field: 'title', title: '标题',width:200,align:'center'}
                                ,{field: 'taskLimitTime', title: '完成期限',width:165,align:'center'}
                                ,{field: 'taskType', title: '任务类型',width:90,align:'center'}
                                ,{field: 'taskStatus', title: '任务状态',width:90,align:'center'}
                                ,{field: 'content', title: '内容',width:400,align:'center'}
                                ,{field: 'nopassComment', title: '不合格原因',width:160,align:'center'}
                                ,{title: '操作',toolbar: '#bar', width:100,align:'center'}

                            ]]
                        })
                    }
                }
            })

        }

        //刷新已完成任务
        function updateDone() {
            $.ajax({
                url: '<%=basePath%>task_listDoneByReceiver.action',
                type: 'post',
                data: {"receiver": '<%=u.getUserNickname()%>'},
                success: function (data) {
                    if (data.code == 200) {
                        table.render({
                            elem: '#doneTable', //指定原始表格元素选择器
                            data: data.paramList,     //相当于code.paramlist
                            page: { //支持传入 laypage 组件的所有参数（某些参数除外，如：jump/elem） - 详见文档
                                layout: ['limit', 'count', 'prev', 'page', 'next', 'skip'] //自定义分页布局
                                , count: 100
                                , curr: 1 //设定初始在第 5 页
                                , groups: 3 //只显示 1 个连续页码
                                , first: false //不显示首页
                                , last: false //不显示尾页
                            },
                            cols: [[ //表头
                                {field: 'recordId', title: '任务ID', width: 75, align: 'center'}
                                , {field: 'creater', title: '创建者', width: 75, align: 'center'}
                                , {field: 'receiver', title: '接收人', width: 75, align: 'center'}
                                , {field: 'createTime', title: '创建时间', width: 165, align: 'center'}
                                , {field: 'taskType', title: '任务类型', width: 90, align: 'center'}
                                , {field: 'title', title: '标题', width: 150, align: 'center'}
                                , {field: 'content', title: '内容', width: 210, align: 'center'}
                                , {field: 'reportTime', title: '完成时间', width: 165, align: 'center'}
                                , {field: 'report', title: '任务报告', width: 590, align: 'center'}

                            ]]
                        })
                    }
                }
            })

        }

        //刷新我创建的任务
        function updateCreate() {
            $.ajax({
                url: '<%=basePath%>task_listFatherByCreater.action',
                type: 'post',
                data: {"creater": '<%=u.getUserNickname()%>'},
                success: function (data) {
                    if (data.code == 200) {
                        table.render({
                            elem: '#createTable', //指定原始表格元素选择器
                            data: data.paramList,     //相当于code.paramlist
                            page: { //支持传入 laypage 组件的所有参数（某些参数除外，如：jump/elem） - 详见文档
                                layout: ['limit', 'count', 'prev', 'page', 'next', 'skip'] //自定义分页布局
                                , count: 100
                                , curr: 1 //设定初始在第 5 页
                                , groups: 3 //只显示 1 个连续页码
                                , first: false //不显示首页
                                , last: false //不显示尾页
                            },
                            cols: [[ //表头
                                /*{type: 'checkbox', fixed: 'left'}
                                ,*/
                                {field: 'taskId', title: '任务ID', width: 75, align: 'center'}
                                , {field: 'receiver', title: '接收人', width: 167, align: 'center'}
                                , {field: 'createTime', title: '创建时间', width: 165, align: 'center'}
                                , {field: 'title', title: '标题', width: 200, align: 'center'}
                                , {field: 'taskType', title: '任务类型', width: 90, align: 'center'}
                                , {field: 'repeatChinese', title: '重复方式', width: 152, align: 'center'}
                                , {field: 'content', title: '内容', width: 400, align: 'center'}
                                , {field: 'taskLimitTime', title: '完成期限', width: 165, align: 'center'}
                                , {title: '任务状态', toolbar: '#bar3', width: 90, align: 'center'}
                                , {title: '取消任务', toolbar: '#bar2', width: 90, align: 'center'}
                            ]]
                        })
                    }
                }
            })
        }

        //刷新“待办事项”选项卡
        function updateBacklog(){
            updateBacklogNotSetTime();
            updateTodayBacklog();
        }

        //刷新四象限待安排表
        function updateBacklogNotSetTime() {
            $.ajax({
                url: '<%=basePath%>backlog_listByPriority.action',
                type: 'post',
                data: {"priority": '重要紧急',
                    "userId":<%=u.getUserId()%>},
                success: function (data) {
                    if (data.code == 200) {
                        table.render({
                            elem: '#backlogTable1', //指定原始表格元素选择器
                            data: data.paramList,     //相当于code.paramlist
                            page: { //支持传入 laypage 组件的所有参数（某些参数除外，如：jump/elem） - 详见文档
                                layout: ['limit', 'count', 'prev', 'page', 'next', 'skip'] //自定义分页布局
                                , count: 100
                                , curr: 1 //设定初始在第 5 页
                                , groups: 3 //只显示 1 个连续页码
                                , first: false //不显示首页
                                , last: false //不显示尾页
                            },
                            cols: [[ //表头
                                {field: 'createTime', title: '创建时间', width: 165, align: 'center'}
                                , {field: 'content', title: '内容', align: 'center'}
                                , {title: '操作', toolbar: '#bar4', width: 160, align: 'center'}
                            ]]
                        })
                    }
                }
            })
            $.ajax({
                url: '<%=basePath%>backlog_listByPriority.action',
                type: 'post',
                data: {"priority": '重要不紧急',
                    "userId":<%=u.getUserId()%>},
                success: function (data) {
                    if (data.code == 200) {
                        table.render({
                            elem: '#backlogTable2', //指定原始表格元素选择器
                            data: data.paramList,     //相当于code.paramlist
                            page: { //支持传入 laypage 组件的所有参数（某些参数除外，如：jump/elem） - 详见文档
                                layout: ['limit', 'count', 'prev', 'page', 'next', 'skip'] //自定义分页布局
                                , count: 100
                                , curr: 1 //设定初始在第 5 页
                                , groups: 3 //只显示 1 个连续页码
                                , first: false //不显示首页
                                , last: false //不显示尾页
                            },
                            cols: [[ //表头
                                {field: 'createTime', title: '创建时间', width: 165, align: 'center'}
                                , {field: 'content', title: '内容', align: 'center'}
                                , {title: '操作', toolbar: '#bar4', width: 160, align: 'center'}
                            ]]
                        })
                    }
                }
            })
            $.ajax({
                url: '<%=basePath%>backlog_listByPriority.action',
                type: 'post',
                data: {"priority": '不重要紧急',
                    "userId":<%=u.getUserId()%>},
                success: function (data) {
                    if (data.code == 200) {
                        table.render({
                            elem: '#backlogTable3', //指定原始表格元素选择器
                            data: data.paramList,     //相当于code.paramlist
                            page: { //支持传入 laypage 组件的所有参数（某些参数除外，如：jump/elem） - 详见文档
                                layout: ['limit', 'count', 'prev', 'page', 'next', 'skip'] //自定义分页布局
                                , count: 100
                                , curr: 1 //设定初始在第 5 页
                                , groups: 3 //只显示 1 个连续页码
                                , first: false //不显示首页
                                , last: false //不显示尾页
                            },
                            cols: [[ //表头
                                {field: 'createTime', title: '创建时间', width: 165, align: 'center'}
                                , {field: 'content', title: '内容', align: 'center'}
                                , {title: '操作', toolbar: '#bar4', width: 160, align: 'center'}
                            ]]
                        })
                    }
                }
            })
            $.ajax({
                url: '<%=basePath%>backlog_listByPriority.action',
                type: 'post',
                data: {"priority": '不重要不紧急',
                    "userId":<%=u.getUserId()%>},
                success: function (data) {
                    if (data.code == 200) {
                        table.render({
                            elem: '#backlogTable4', //指定原始表格元素选择器
                            data: data.paramList,     //相当于code.paramlist
                            page: { //支持传入 laypage 组件的所有参数（某些参数除外，如：jump/elem） - 详见文档
                                layout: ['limit', 'count', 'prev', 'page', 'next', 'skip'] //自定义分页布局
                                , count: 100
                                , curr: 1 //设定初始在第 5 页
                                , groups: 3 //只显示 1 个连续页码
                                , first: false //不显示首页
                                , last: false //不显示尾页
                            },
                            cols: [[ //表头
                                {field: 'createTime', title: '创建时间', width: 165, align: 'center'}
                                , {field: 'content', title: '内容', align: 'center'}
                                , {title: '操作', toolbar: '#bar4', width: 160, align: 'center'}
                            ]]
                        })
                    }
                }
            })
        }

        //刷新今日安排表
        function updateTodayBacklog(){
            $.ajax({
                url: '<%=basePath%>backlog_listSetTime.action',
                type: 'post',
                data: {
                    "userId":<%=u.getUserId()%>},
                success: function (data) {
                    if (data.code == 200) {
                        table.render({
                            elem: '#toadyBacklogTable',
                            data: data.paramList,
                            cols: [[
                                {field: 'timeSlot', title: '时间安排', align: "center", width: 110, sort: true}
                                , {field: 'priority', title: '重要紧急程度', align: "center", width: 120}
                                , {field: 'content', title: '内容', align: "center"}
                                , {title: '操作', toolbar: '#bar5', width: 120, align: 'center'}
                            ]]
                        })
                    }
                }
            })
        }

        //刷新已完成待办事项表
        function updateDoneBacklog(){
            $.ajax({
                id:"updateDoneBacklog",
                url: '<%=basePath%>backlog_listByStatus.action',
                type: 'post',
                data: {"backlogStatus":"已完成",
                    "userId":<%=u.getUserId()%>},
                success: function (data) {
                    if (data.code == 200) {
                        table.render({
                            elem: '#doneBacklogTable',
                            data: data.paramList,
                            cols: [[
                                {field: 'createTime', title: '创建时间', align: "center", width: 180}
                                ,{field: 'doneTime', title: '完成时间', align: "center", width: 180}
                                ,{field: 'timeSlot', title: '时间安排', align: "center", width: 117}
                                ,{field: 'priority', title: '重要紧急程度', align: "center", width: 120}
                                ,{field: 'content', title: '内容', align: "center"}
                            ]]
                        })
                    }
                }
            })
        }

        //待办事项定时冲突后，强行插入
        function insertBacklog(userId,recordId,startTime,endTime) {
            layer.open({
                title: '待办事项插入确认',
                area :['260px','220px'],
                content: "此待办事项时间设定与现有日程表时间冲突，是否插入此事项，将冲突事项时间顺延？",
                btn: ["确定", "取消"],
                btnAlign: 'c',
                closeBtn: 0,
                btn1: function () {
                    $.ajax({
                        url: '<%=basePath%>backlog_insert.action',
                        type: 'post',
                        data: {
                            "userId": userId,
                            "recordId":recordId,
                            "startTimeStr": startTime,
                            "endTimeStr": endTime,
                        },
                        success: function (data) {
                            if (data.code == 200) {
                                layer.closeAll();
                                layer.msg("待办事项插入成功");
                                updateBacklog();
                            }
                        }
                    })
                },
                btn2: function () {
                    layer.closeAll();
                    layer.msg("时间设定与现有日程表冲突，请重新设置。");
                    document.getElementById("setBacklogTime").reset();
                }
            });
        }

    </script>
</html>