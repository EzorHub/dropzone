<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<!-- Dropzone css -->
  <link href="lib/dropzone/dropzone.css" rel="stylesheet">
<!--   <link rel="stylesheet" href="dz/basic.css"> -->

<style type="text/css">
/* body {
    background: rgb(243, 244, 245);
    height: 100%;
    color: rgb(100, 108, 127);
    line-height: 1.4rem;
    font-family: Roboto, "Open Sans", sans-serif;
    font-size: 20px;
    font-weight: 300;
    text-rendering: optimizeLegibility;
} */

h3#dz_title { 
margin:5px; 
padding: 2px;
text-align: center; 
}
.dropzone {
	resize:none;
    background: white;
    border-radius: 5px;

    border: 1px solid #e17804; 
    border-image: none;
    max-width: 700px;
    margin-left: auto;
    margin-right: auto;
    text-align: center;
}
#removed { position : absolute; bottom: -20; left : 0; margin : 0px !important; width: 100%; background-color: #f4923d; !important; }
.dropzone .dz-preview .dz-image { border-radius: 0 !important; margin-top: -10px !important;}
</style>
<script type="text/javascript" src="https://code.jquery.com/jquery-3.4.1.min.js">
</script>
<script type="text/javascript">
$(function(){
	$("#fileupload").on('click', function(){
		alert('버튼 누름')
	});
})
</script>
</head>
<body>
<div id="_dz_" style="border-top: -50px;">
<h3 id="dz_title" style="color: gray;">카페 메인사진 및 내부 사진을 첨부해주세요</h3> 

<SECTION>
  <DIV id="dropzone">
    <FORM class="dropzone needsclick" id="demo-upload" action="upload.do" method="post" enctype="multipart/form-data">
      <DIV style="font-size: 12px;" class="dz-message needsclick">    
       업로드할 파일을 <b>클릭</b>하여 선택하거나 여기로 <b>드래그</b> 해주세요.<BR>
        <SPAN style="color:#e17804; " class="note needsclick"><b>첫번째 사진</b>이 카페목록의 <b>대표사진</b>으로 보여집니다.</SPAN>
        
      </DIV>
    </FORM>
    <button id="BTNfileupload" style="float: right;">업로드</button>     
  </DIV>
</SECTION>
</div>
<br>


<script  src="lib/dropzone/dropzone.js"></script>
<script>
Dropzone.autoDiscover = false;
var arFiles = [];
/*var arExistingFiles; */
if ($('#demo-upload').length) {
	  $("div#demo-upload").dropzone({ url: "/testDZ" });
	  var dropzone = new Dropzone('#demo-upload', {
		  maxFiles:4,
		  parallelUploads: 2,
		  thumbnailHeight: 120,
		  thumbnailWidth: 120,
		  maxFilesize: 3,
		  autoProcessQueue: false,

		  filesizeBase: 1000/* ,
		  thumbnail: function(file, dataUrl) {
		    if (file.previewElement) {
		      file.previewElement.classList.remove("dz-file-preview");
		      var images = file.previewElement.querySelectorAll("[data-dz-thumbnail]");
		      for (var i = 0; i < images.length; i++) {
		        var thumbnailElement = images[i];
		        thumbnailElement.alt = file.name;
		        thumbnailElement.src = dataUrl;
		      }
		      setTimeout(function() { file.previewElement.classList.add("dz-image-preview"); }, 1);
		    }
		  } */

		,init: function(e) {
			  $('#BTNfileupload').on("click", function() {
		            this.processQueue(); // Tell Dropzone to process all queued files.
		        });

  	      this.on("addedfile", function(file) {            	    
  	    	
  	         var removeButton = Dropzone.createElement("<button id='removed' class='btn-primary btn-xs'>삭&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;제</button>");
			 var _this = this;
			    
  	        removeButton.addEventListener("click", function(e) {
  	          e.preventDefault();
  	          e.stopPropagation();         	          
  	       
  	          _this.removeFile(file);
  	          // If you want to the delete the file on the server as well,
  	          // you can do the AJAX request here.
  	        });
  	        file.previewElement.appendChild(removeButton); 
  	      
  	      });
  	      
  	      this.on("error", function(file, response) {
              var _this = this;                
              var index = dropzone.files.map(function (obj, index) {
                    if (file == obj) {
                        return index;
                    }
                }).filter(isFinite)[0];
               if(index == 4){
            	   _this.removeFile(file);            	  
            	   arFiles.pop();
            	   response = "파일은 최대 4개까지 업로드 가능합니다.";
                   alert(response).one(); // one 말고 다른 문법은 없음? html console에서 오류남 혹은 아예 비활성화되거나 자동 삭제 되는 방법은 없는지? 
               }
        	}, 
        	this.on("sending", function(file, xhr, data) {

                // First param is the variable name used server side
                // Second param is the value, you can add what you what
                // Here I added an input value
                data.append("your_variable", $('input[type=file]').val());
            })
        	
  	      
  	      );
		  }, accept: function(file, done) {
			  arFiles.push(file.name);
			  var extension = file.name.substring(file.name.lastIndexOf('.')+1);
	          //console.log("extension - " + extension + ", arExistingFiles - " + arExistingFiles);
	          if (extension == "exe" || extension == "bat") {
	              done("Error! File(s) of these type(s) are not accepted.");
	          } else { 
		          done(); 
		          console.log(arFiles);
	          }
	          
	         
	      }
		  
		  
		/*   accept: function(file, done) 
		   {
		        var re = /(?:\.([^.]+))?$/;
		        var ext = re.exec(file.name)[1];
		        
		        
		         alert('filename: '+file.name); 
		      	
		        
		        ext = ext.toUpperCase();
		        if ( ext == "JPG" || ext == "JPEG" || ext == "PNG" ||  ext == "GIF" ||  ext == "BMP") 
		        {
		            done();
		        }else { 
		            done("Please select only supported picture files."); 
		        }
		    } */
	        
	  });

	}
</script>
</body>
</html>