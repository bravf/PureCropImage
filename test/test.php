<!doctype html>
<html>
    <head>
        <style type="text/css">
        *{
            margin:0;
            padding:0;
        }
        #crop, #Head_Cut_miniblog{
            border:1px solid #000;   
        }
        </style>
    </head>
    <body>
        <div id="crop"></div>
    </body>
</html>

<script src="PureImageCrop.js"></script>
<script>


PureImageCrop({
    "contId" : "crop"                   // flash所需容器id
    ,"uploadUrl" : "upload.php"         // 截取好的图片的上传路径
    ,"imageSize" : "240, 240"           // 所需图片大小
    ,"initImage" : "http://image.ganjistatic1.com/gjfstmp1/M00/6A/E1/CgP,yk,YLdTDcdiOAAA2,PDgkZA756_82-52c_6-0.jpg" // 初始图片
    ,"crossDomainFiles" : "http://image.ganji.com/crossdomain.xml, http://image.ganjistatic1.com/crossdomain.xml"   // 跨域策略文件(逗号隔开)
    ,"onSuccess" : function (retUrl){   // 上传成功回调函数
        alert(retUrl);
    }
    ,"onError" : function (ret){        // 失败回调函数
        console.log(ret);
    }
});

</script>