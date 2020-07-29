<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
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
		return con;
	}
%>    
<%
						// 겟/포스트방식 둘다 getParameter로 
	String strI_board = request.getParameter("i_board");
	//String strCtnt = request.getParameter("ctnt");

	BoardVO vo = new BoardVO();
	 

	//밑에서 try안에서 선언안하는 이유? 스코프(살아있는 범위)때문에. 
		//try에서도 사용하고 finally에서도 사용하기 위해서.		
		Connection con = null;
		// 연결담당
		PreparedStatement ps = null;
		// 실행담당
		ResultSet rs = null;
		// 셀렉트문의 결과를 담는 담당
		
	    // " SELECT ~~~ " 따옴표안에 한칸씩 띄우기 
		String sql = " SELECT title, ctnt, i_student FROM t_board WHERE i_board = " + strI_board;
		
		try{
			con = getCon();		
			ps = con.prepareStatement(sql);
			rs = ps.executeQuery();
			//executeQuery 셀렉트때만 쓰는 쿼리 
			//나머지는 executeupdate?
			
			// 행이 있을때까지 계속 true , 행이 한줄이면 if쓰기도 함
			while(rs.next()){
				String title = rs.getNString("title");
				String ctnt = rs.getNString("ctnt");
				int i_student = rs.getInt("i_student");
				
				// 개중요개중요개중요 ! BoardVO의 객체생성을  무조건 while문 안에서 해야됨 아니면 다 같은값나옴!!
				
				vo.setTitle(title);
				vo.setCtnt(ctnt);
				vo.setI_student(i_student);				
				
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
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>상세 페이지</title>
<style>
	* { background: skyblue; }
	.container { width: 100%; height: 100px; margin: 0 auto;
					 }
	h2 { display: block; text-align: center; font-size: 100px;}
	table { border-collapse: collapse; margin: 0 auto; }
	tr, th, td { text-align: center; font-size: 50px; }
</style>
</head>
<body>
	<div class="container">
	<h2><%=strI_board  %>페이지 입니당</h2>
	<table>
		<tr>
			<th>내용은</th>		
		</tr>
		<tr>
			<td><%= vo.getCtnt() %>입니당</td>
		</tr>
		<tr>
			<td><h3><%= vo.getI_student() %>번 학쉥이 썼습니당</h3></td>
		</tr>
	</table>
	</div>
</body>
</html>