<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreait.web.BoardVO"%>
<%!
	private Connection getCon() throws Exception {
	
		String url = "jdbc:oracle:thin:@localhost:1521:orcl2";
		String username = "hr";
		String password = "koreait2020";
		
		Class.forName("oracle.jdbc.driver.OracleDriver");
		
		//getConnection은 DriverManager클래스(대문자시작이니까)의 static메소드->생성안해줘도 사용가능
		Connection con = DriverManager.getConnection(url, username, password);
		System.out.println("접속성공");
		//
		return con;
	}
%>
<%


	List<BoardVO> boardList = new ArrayList();

	//밑에서 try안에서 선언안하는 이유? 스코프(살아있는 범위)때문에. 
	//try에서도 사용하고 finally에서도 사용하기 위해서.		
	Connection con = null;
	// 연결담당
	PreparedStatement ps = null;
	// 실행담당
	ResultSet rs = null;
	// 셀렉트문의 결과를 담는 담당
	
    // " SELECT ~~~ " 따옴표안에 한칸씩 띄우기 
	String sql = " SELECT i_board, title, ctnt, i_student FROM t_board ORDER BY i_board DESC ";
	
	try{
		con = getCon();		
		ps = con.prepareStatement(sql);
		rs = ps.executeQuery();
		//executeQuery 셀렉트때만 쓰는 쿼리 
		//나머지는 executeupdate?
		
		// 행이 있을때까지 계속 true , 행이 한줄이면 if쓰기도 함
		while(rs.next()){
			int i_board = rs.getInt("i_board"); //"i_board" 는 컬럼명
			String title = rs.getNString("title");
			
			BoardVO vo = new BoardVO();
			// 개중요개중요개중요 ! BoardVO의 객체생성을  무조건 while문 안에서 해야됨 아니면 다 같은값나옴!!
			vo.setI_board(i_board);
			vo.setTitle(title);
			//
			boardList.add(vo);
			
		}
		
		
	} catch(Exception e) {
		e.printStackTrace();
		
	} finally {
		// 만약에 안닫아주면? 서버가 죽는당
		// 닫을때는 반대로 닫아야한다. rs -> ps -> con
		// 3개를 다 같이 한번에 안닫는 이유? 다 묶어주면 하나가 에러터지면 그 뒤에 있는건 실행안되서 안닫힘.
		if(rs != null) { try{ rs.close(); } catch(Exception e) {} }
		if(ps != null) { try{ ps.close(); } catch(Exception e) {} }
		if(con != null) { try{ con.close(); } catch(Exception e) {} }
		
	}


%>
<!-- 여기서부터는 다 문자열임 -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300&display=swap');
html, body {
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 400;
	padding: 0;
	margin: 0;
	width: 100%;
	height: 100%;
}

#container { 
	height: 100%;
	display: flex;
	justify-content: center;
	align-items: center;
} 	

.listtitle { 

	text-align: right;
	font-size: 20px;
	font-weight: bolder;

}

.writebutton { 
	display: flex;
	justify-content: flex-end;
}

button { 
	background-color: white; 
	font-size: 10px;
	width: 60px; height: 25px;
	border: 1px solid black;
	cursor: pointer;
}

table { 
	margin-top: 10px;
	border-collapse: collapse; 
}

a {
	text-decoration: none;
	color: black;
}

tr, td { 
	height: 30px; 
	font-size: 12px;
}

tr td:nth-child(1) { 
	text-align: center;
}
tr td:nth-child(2) { 	
	padding-left: 30px; 
	width: 300px;  
}


</style>
</head>
<body>
	<div id="container">
		<div>
			<div class="list"><p class="listtitle">게시판<br>리스트</p></div>
			<div class="writebutton"><a href="/jsp/boardWrite.jsp"><button>글쓰기</button></a></div>
			<table>
				<tr>
					<th>No</th>
					<th>제목</th>
				</tr>
				
				<% for(BoardVO vo : boardList) { %>
				<tr>
					<td><%=vo.getI_board() %></td>
					<td class="content">
					<!-- 
						https://search.naver.com/search.naver?sm=top_hty&fbm=0&ie=utf8&query=레드벨벳 
														sm -> pk값 / top_hty -> value	
														?가 쿼리스트링 시작
					-->
					
						<a href="/jsp/boardDetail.jsp?i_board=<%=vo.getI_board() %>">
							<%=vo.getTitle() %>
						</a>
					</td>
				</tr>
				<% } %>
			</table>
		</div>
	</div>
</body>
</html>