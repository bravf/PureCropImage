void function (){
    var id = 0;
    var uid = function (){
        return ("PIC_" + (new Date).getTime() + "_" + Math.random() + "_" + id++).replace(/\./g,"_");
    };

    var formatStr = function (tmpl, datas){
        datas = [].concat(datas);
        var rs = [];

        for(var i=0,len=datas.length,t,data; i<len; i++){
            data = datas[i];
            t = tmpl.replace(/{([^{}]+)}/g,function (m,v) {
                return data[v] === undefined ? "" : data[v];
            });
            rs.push(t);
        }

        return rs.join("");
    };
    // for ie6
    var printFlash = function (swf, contId, width, height, flashvars){
        var flashvars_str = [];
        for (var v in flashvars){
            flashvars_str.push(v+"="+flashvars[v]);
        }
        flashvars_str = flashvars_str.join("&");
        swf = swf + "?" + flashvars_str;

        var tmpl = [
            '<object id="{contId}_crop" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0" width="{width}" height="{height}">'
            ,'<embed src="{swf}" type="application/x-shockwave-flash" wmode="transparent" width="{width}" height="{height}" swliveconnect="true" allowscriptaccess="always" name="{contId}">'
            ,'<param name="movie" value="{swf}">'
            ,'<param name="quality" value="high">'
            ,'<param name="wmode" value="transparent">'
            ,'<param name="allowScriptAccess" value="always">'
            ,'</object>'
        ].join("");

        return formatStr(tmpl, {"swf" : swf, "contId" : contId, "width" : width, "height" : height, "flashvars" : flashvars_str});
    };

    window.PureImageCrop = function (opts){
        if (typeof opts["uploadUrl"] != "string") throw "缺少上传url";
        if (typeof opts["contId"] != "string") throw "缺少容器id";

        var flashvars = {};
        flashvars["uploadUrl"] = opts["uploadUrl"];
        
        if (opts["onSuccess"]) {
            var cbSuccessName = uid() + "_succ"; 
            window[cbSuccessName] = opts["onSuccess"];
            flashvars["cbSuccess"] = cbSuccessName;
        }

        if (opts["onError"]) {
            var cbErrorName = uid() + "_err";
            window[cbErrorName] = opts["onError"];
            flashvars["cbError"] = cbErrorName;
        }

        if (opts["initImage"]) {
            flashvars["initImage"] = opts["initImage"];
        }

        if (opts["crossDomainFiles"]) {
            flashvars["crossDomainFiles"] = opts["crossDomainFiles"];
        }

        if (opts["imageSize"]){
            flashvars["imageSize"] = opts["imageSize"];
        }

        var flashAttrs = {
            "allowScriptAccess":"always"
            ,"movie" : "PureImageCrop.swf"
            ,"quality" : "high"
            ,"wmode" : "transparent"
        };
        
        document.getElementById(opts["contId"]).innerHTML = printFlash("PureImageCrop.swf", opts["contId"], 700, 470, flashvars);

        //swfobject.embedSWF("PureImageCrop.swf", opts["contId"], 700, 470, "11.3.0", "playerProductInstall.swf", flashvars, flashAttrs);
        /*var ie6=!-[1,]&&!window.XMLHttpRequest;
        if (ie6){
            document.getElementById(opts["contId"]).innerHTML = printFlash("PureImageCrop.swf", opts["contId"], 700, 470, flashvars);
        }
        else {
            swfobject.embedSWF("PureImageCrop.swf", opts["contId"], 700, 470, "11.3.0", "playerProductInstall.swf", flashvars, null);
        }*/
    };
}();