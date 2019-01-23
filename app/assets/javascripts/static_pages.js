
window.my_map={}

$(function(){
  get_thumb_up();

})


function get_thumb_up(){

    $.ajax({
        type:"POST",

        url:"http://45.32.60.32:8080/web_thumb/get_thumb_up",


        success:function(data){
            console.log("..."+data)

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