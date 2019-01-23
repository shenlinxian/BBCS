

$(function(){

    show_thumb_num();
    /*建立一个函数*/
    $(".btn").click(function(){
        sleep(1000)
        var num;
        var id;
        $(".for_id").each(function(){
            console.log($(this).attr("id"));
            var temp_id=$(this).attr("id")
            id=parseInt(temp_id)
            num=window.my_map[id];


        });


        /*获取到id执行点击事件*/
        if ($(this).attr("data-key")=="on") {

            $(this).addClass("on");
            //var num=Number($(this).find("span").html())+1;
            num=num+1;
            window.my_map[id]+=1
            /*给变量赋值当.btn点击执行b标签内容=+1*/
            $(this).find("span").html(num);
            $(this).attr("data-key","")

            thumb_up_num(id,1)


            var css_ele=document.getElementById("thumb_up_css")
            css_ele.style.setProperty("color",'red')

        }else{

            $(this).removeClass("on");
            //var num=Number($(this).find("span").html())-1;
            num=num-1;
            $(this).find("span").html(num);
            $(this).attr("data-key","on");
            window.my_map[id]-=1
            thumb_up_num(id,-1)
            var css_ele=document.getElementById("thumb_up_css")
            css_ele.style.setProperty("color",'black')
        }

    })

})

function upload_thumb_up_num(my_map) {
    $.ajax({
        type:"POST",

        url:"http://localhost:3000/upload_thumb_up_num",
        data:"username="+"1",

        success:function(data){
            my_map={}

            var arr=data.split('=')
            //code result
            var arr1=arr[1].split(",");
            var code=arr1[0]

            //number
            obj=arr[2].substring(0,arr[2].length-1)
            json_obj=JSON.parse(obj);
            for(var i=0;i<json_obj.length;i++){

                temp_key=json_obj[i]["id"]
                temp_value=json_obj[i]["num"]
                window.my_map[temp_key]=temp_value
            }
            console.log(window.my_map)

        }
    })

}


function thumb_up_num(id,num) {
    $.ajax({
        type:"POST",

        url:"http://45.32.60.32:8080/web_thumb/thumb_up",
        data:"id="+id+"&num="+num,

        success:function(data){
            console.log(data)
        }
    })

}


function get_thumb_up(){

    $.ajax({
        type:"POST",

        url:"http://45.32.60.32:8080/web_thumb/get_thumb_up",
        data:"username="+"1",

        success:function(data){
            my_map={}

            var arr=data.split('=')
            //code result
            var arr1=arr[1].split(",");
            var code=arr1[0]

            //number
            obj=arr[2].substring(0,arr[2].length-1)
            json_obj=JSON.parse(obj);
            for(var i=0;i<json_obj.length;i++){

                temp_key=json_obj[i]["id"]
                temp_value=json_obj[i]["num"]
                window.my_map[temp_key]=temp_value

            }
            console.log(window.my_map)
            //upload_thumb_up_num(my_map)







        }
    })
}

//页面加载完后才执行js
function show_thumb_num(){
    //sleep(10000)
    //获取for_id class标签id
    $(".for_id").each(function(){
        console.log($(this).attr("id"));
        var temp_id=$(this).attr("id")
        var id=parseInt(temp_id)
        var num=window.my_map[id];
        //document.getElementById(id).html(num)
        $('#1').html(num);

    });

}

function sleep(numberMillis) {
    var now = new Date();
    var exitTime = now.getTime() + numberMillis;
    while (true) {
        now = new Date();
        if (now.getTime() > exitTime)
            return;
    }
}