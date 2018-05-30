<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@include file="../zinclude/header.jsp"%>

<!-- ...590p. -->
<style>
.fileDrop {
  width: 80%;
  height: 100px;
  border: 1px dotted gray;
  background-color: lightslategrey;
  margin: auto;  
}
.popup {position: absolute;}
.back { background-color: green; opacity:0.5; width: 100%; height: 300%; overflow:hidden;  z-index:1101;}
.front { 
   z-index:1110; opacity:1; boarder:1px; margin: auto; 
}
.zbtn-green {
  color: #fff;
  background-color: #00A65A;
  border-color: #367fa9;
}
</style>

<!--...첨부하려는 이미지파일명을 클릭하면 이미지가 슬라이드로 글쓰기화면 위에 뜸. -->
<div class='popup back' style="display:none;"></div>
<div id="popup_front" class='popup front' style="display:none;">
 <img id="popup_img">
</div>

<!-- Main content -->
<section class="content">
	<div class="row">
		<!-- left column -->
		<div class="col-md-12">
			<!-- general form elements -->
			<div class="box box-primary">
				<div class="box-header">
					<h3 class="box-title">REGISTER BOARD</h3>
				</div>
				<!-- /.box-header -->

<!-- 202p. form::action 속성이 지정되지 않으면 현재 경로를 그대로 action의 대상 경로로 잡음. -->
<form role="form" method="post"
	  id = "registerForm"> <!-- ...595p.submit처리를 위해 id값을 설정함. -->
	<div class="box-body">
		<div class="form-group">
			<label for="exampleInputEmail1">Title</label> 
			<input type="text"
				name='title' class="form-control" placeholder="Enter Title">
		</div>
		<div class="form-group">
			<label for="exampleInputPassword1">Content</label>
			<textarea class="form-control" name="content" rows="3"
				placeholder="Enter ..."></textarea>
		</div>
		<div class="form-group">
			<label for="exampleInputEmail1">Writer</label> 
			<input type="text"
				name="writer" class="form-control" placeholder="Enter Writer">
		</div>
		<!-- ...S.590p. 첨부파일 추가영역과 업로드된 파일 보여주는 ul태그.-->	
		<div class="form-group">
			<label for="exampleInputEmail1">File DROP Here</label>
			<div class="fileDrop"></div>
		</div>
		<!-- ...E.590p. 첨부파일 추가영역과 업로드된 파일 보여주는 ul태그.-->		
	</div>
	<!-- /.box-body -->

	<div class="box-footer">
	<!-- ...S.590p. 첨부파일 추가영역과 업로드된 파일 보여주는 ul태그.-->
		<div>
			<hr>
		</div>
		
		<ul class="mailbox-attachments clearfix uploadedList">
		</ul>
	<!-- ...E.590p. 첨부파일 추가영역과 업로드된 파일 보여주는 ul태그.-->
	
		<button type="submit" class="btn btn-primary">Submit</button>
		<button type="reset" class="btn btn-warning">CANCEL</button>
		<button type="submit" class="btn zbtn-green" id="listBtn">Go List</button>		
	</div>
</form>

			</div>
			<!-- /.box -->
		</div>
		<!--/.col (left) -->

	</div>
	<!-- /.row -->
</section>
<!-- /.content -->
</div>
<!-- /.content-wrapper -->

<!-- 
	...591p.첨부파일을 보여주는 HTML코드가 복잡하므로 handlebars를 이용하여
	...첨부된 각각의 파일을 보여주는 화면을 템플릿으로 작성함.  
	...li태그를 구성할 때 'imgsrc'속성을 보여주는데, 'imgsrc'는 이미지 파일인 경우
	...썸네일 파일의 경로이고, 일반 파일인 경우는 단순히 파일모양의 이미지(file.png)를
	...보여주는 경로임.
-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.1/handlebars.js"></script>

<!-- 
	...595p.getFileInfo()는 별도의 JavaScript 파일로 작성함.
	...별도의 파일로 하고 실행하니까 브라우저 검사에서 getFileInfo()를 인식할 수 없다고
	...오류가 나서 같은 소스에 두고 실행하니까 되었다.
	...[Solved]WEB-INF폴더를 기준으로 resources폴더로 상대경로를 이용하여 위치를 표기하면 된다.
	...script type="text/javascript" src="../resources/zjs/upload.js"		
	...정상실행된 모습은 이미지를 Drop구역에 놓으면, submit버튼 위에 썸네일이미지와 파일명이
	...링크형태로 뜬다.
 -->
<script type="text/javascript" src="../resources/zjs/upload.js"></script>

<script id="template" type="text/x-handlebars-template">
<li>
  <span class="mailbox-attachment-icon has-img">
	<img src="{{imgsrc}}" alt="Attachment">
  </span>
  <div class="mailbox-attachment-info">
	<a href="{{getLink}}" class="mailbox-attachment-name">{{fileName}}</a>

	<a href="{{fullName}}" class="btn btn-default btn-xs pull-right delbtn">
		<i class="fa fa-fw fa-remove"></i>
	</a>
	</span>
  </div>
</li>        
</script>  

<!-- 
	...593p.
	...Drag&Drop으로 파일이 업로드되는 과정.
	...1. 서버에 업로드된 파일의 이름.
	...↓
	...2. getFileInfo()를 통한 정보 추출.
	...↓
	...3. JavaScript객체 생성.
	...↓
	...4. handlebars적용.
	...↓
	...5. HTML생성.
	...↓
	...6. 화면적용.
 --> 
<script>
	var template = Handlebars.compile($("#template").html());
	
	$(".fileDrop").on("dragenter dragover", function(event){
		event.preventDefault();
	});
	
	
	$(".fileDrop").on("drop", function(event){
		event.preventDefault();
		
		var files = event.originalEvent.dataTransfer.files;
		
		var file = files[0];
	
		var formData = new FormData();
		
		formData.append("file", file);	
		
		
		$.ajax({
			  url: '/z4b/uploadAjax', //...UploadController 참조.
			  data: formData,
			  dataType:'text',
			  processData: false,
			  contentType: false,
			  type: 'POST',
			  success: function(data){
				  //...593p.
				  //...getFileInfo()를 이용해서 템플릿에 필요한 객체를 생성함.
				  //...이후 템플릿을 적용해서 온전한 HTML을 구성한 후 첨부된 파일이
				  //...보여지는 $(.'uploadedList')의 일부로 추가됨.
				  //...getFileInfo()는 별도의 자바스크립트 파일로 구성함.
				  var fileInfo = getFileInfo(data);
				  
				  var html = template(fileInfo);
				  
				  $(".uploadedList").append(html);
			  }
			});	
	});
	
	$(".uploadedList").on("click", ".delbtn", function(event){
		
		event.preventDefault();
		console.log("delbtn clicked...");
		var that = $(this);
		 
		$.ajax({
		   url:"/z4b/deleteFile",
		   type:"post",
		   data: {fileName:$(this).attr("href")},
		   dataType:"text",
		   success:function(result){
			   if(result == 'deleted'){
				   that.closest("li").remove();
			   }
		   }
	   });
	});		
</script>

<!-- 
	...595p.form태그의 submit을 처리하는 스크립트.
	...form태그의 submit은 먼저 기본 동작을 막고, 현재까지 업로드된 파일들을 form태그의
	...내부에 input type = 'hidden'으로 추가함.
	...이때 각 파일은 'files[0]'과 같은 이름으로 추가되는데, 이 배열 표시를 이용해서
	...컨트롤러에서는 BoardVO의 files파라미터를 수집하게 됨.
	...that.get(0)의 get(0)은 순수한 DOM객체를 얻어내기 위해서 사용함.
 -->
<script>
$("#registerForm").submit(function(event){
	event.preventDefault();
	
	var that = $(this);
	
	var str ="";
	
	$(".uploadedList .delbtn").each(function(index){
		 str += "<input type='hidden' name='files["+index+"]' value='"+$(this).attr("href") +"'> ";
	});
	
	that.append(str);

	that.get(0).submit();
});


$(".uploadedList").on("click", ".mailbox-attachment-name", function(event){
	
	var fileLink = $(this).attr("href");
	
	if(checkImageType(fileLink)){
		
		event.preventDefault();
				
		var imgTag = $("#popup_img");
		imgTag.attr("src", fileLink);
		
		//console.log('imgTag.attr = ' + imgTag.attr("src"));
				
		$(".popup").show('slow');
		imgTag.addClass("show");		
	}	
});

$("#popup_img").on("click", function(){
	
	$(".popup").hide('slow');
	
});	
</script>

<script type="text/javascript">
//...ref : http://pjh445.blog.me/220793204267
$("#listBtn").on("click", function(){
	event.preventDefault();
	console.log("listBtn clicked...");
	window.history.back();
	
});
</script>

<%@include file="../zinclude/footer.jsp"%>





