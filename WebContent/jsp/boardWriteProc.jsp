<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

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
	// post 방식으로 할때 한글이 깨지지 않게 하기 위해
	// get 방식은 이미 해놨음. 지난번에 메모장에서 URIEncoding 어쩌고 저쩌고
	// (밑)외부로부터 값을 받는 작업
	String title = request.getParameter("title");
	String ctnt = request.getParameter("ctnt");
	String strI_student = request.getParameter("i_student");
	
	if("".equals(title) || "".equals(ctnt) || "".equals(strI_student)) {
		response.sendRedirect("/jsp/boardWrite.jsp?err=10");
		return;
	}

	
	int i_student = Integer.parseInt(strI_student);
	
	
	Connection con = null;
	PreparedStatement ps = null;

	String sql = " INSERT INTO t_board(i_board, title, ctnt, i_student) "
			+ " SELECT nvl(max(i_board), 0) + 1, ?, ?, ? "
			+ " FROM t_board ";
	
	int result = -1;
	
	try{
		con = getCon();		
		//(밑) prepareStatement 안해주면 진짜 ?자리에 ?들어가 있음
		ps = con.prepareStatement(sql);
		ps.setString(1, title);
		ps.setString(2, ctnt);
		ps.setInt(3, i_student);

		// (밑)에러여부를 확인하기 위해서 넣는당. 1: 디테일쪽으로 
		result = ps.executeUpdate();
		
		//  switch에서 1, 0, -1에 따라 어디로 이동할지에 대한 값을 준다.
		//  String latest = " SELECT nvl(max(i_board), 0) as latest FROM t_board ";
		
		
	} catch(Exception e) {
		e.printStackTrace();
		
	} finally {
		if(ps != null) { try{ ps.close(); } catch(Exception e) {} }
		if(con != null) { try{ con.close(); } catch(Exception e) {} }
		
	}
	
	int err = 0;
	switch(result) {
		case 1 :
			response.sendRedirect("/jsp/boardlist.jsp");
			//return -> 메소드 자체가 종료된다.
			//break -> switch를 빠져나감
			return;
		case 0 :
			err = 10;
			break;
		case -1 :
			err = 20;
			break;
	}
	response.sendRedirect("/jsp/boardWrite.jsp?err=" + err);

%>