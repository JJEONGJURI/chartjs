<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%--/chartjs/src/main/webapp/db/exam1.jsp --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>파이 그래프로 게시글 작성자의 건수 출력하기</title>
	<script type="text/javascript"
		src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.min.js">
	</script>
</head>
<body>
<sql:setDataSource var="conn" driver="org.mariadb.jdbc.Driver"
	url = "jdbc:mariadb://localhost:3306/gdudb"
	user = "gdu"
	password = "1234" />
<sql:query var="rs" dataSource="${conn}">
SELECT writer, COUNT(*) cnt FROM board where boardid =2 GROUP BY writer HAVING COUNT(*)>1 ORDER BY 2 desc
</sql:query>
<div style="width:75%"><canvas id="canvas"></canvas></div>
<script type="text/javascript">
let randomColorFactor = function() {
	return Math.round(Math.random()*255)
}
let randomColor = function(opacity) { 
	//rgb(255,255,255) =>흰색. = #FFFFFF
	//rgba(255,255,255,1) =>흰색. = #FFFFFF1 => a:투명도. 0:투명/1:불투명
	return "rgba("+ randomColorFactor() + ","
			+ randomColorFactor() + ","
			+ randomColorFactor() + ","
			+ (opacity || '.3') +")" //opacity 값이 있으면 opacity값 넣고 아니면 0.3넣어줌
			//ex) rgba(10,255,5,0.3)형태임
}
let config = {
		labels : [<c:forEach items="${rs.rows}" var="m">"${m.writer}",</c:forEach>],
		datasets : [{
			type : 'pie',
			backgroundColor : [<c:forEach items="${rs.rows}" var="m"> randomColor(1),</c:forEach>],
			label : '파이 그래프',
			data : [<c:forEach items="${rs.rows}" var="m"> "${m.cnt}",</c:forEach>]
		}]
};
window.onload = function() {
	var ctx = document.getElementById('canvas').getContext('2d');
	new Chart(ctx,{
		type : 'pie',
		data : config,
		options : {
			responsive :true, //반응형 
			title : {display :true,
					text: '글쓴이 별 게시판 등록 건수',	
					position : 'bottom'
			},
			legend : {position : 'right'},
			animation : { //모양 예쁘게 처리
				animateScale : true} // 새로고침할 때 작은원이 커짐 / false로 하면 원크기 그대로임
		}
	})
}
</script>
</body>
</html>