<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!-- 밑의 코드를 써야 내용 받을 수 있음 -->
<!-- 각각의 정보를 가져와 user라는 객체완성 -->
<jsp:useBean id="user" class="user.User" scope="page" />
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" />
<jsp:setProperty name="user" property="userName" />
<jsp:setProperty name="user" property="userGender" />
<jsp:setProperty name="user" property="userEmail" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
    <% // java
    //빈공간에 대한 처리
          String userID = null;
          if(session.getAttribute("userID")!= null){
    	    userID = (String) session.getAttribute("userID");
    }
           if(userID != null){
    	    PrintWriter script = response.getWriter();
    	    script.println("<script>");
    	    script.println("alert('이미 로그인이 되어있습니다.')");
    	    script.println("location.href = 'main.jsp'");
    	    script.println("</script>");
    }
        if (user.getUserID() == null || user.getUserPassword() == null || user.getUserName() == null 
        || user.getUserGender() == null || user.getUserEmail() == null) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('입력이 안 된 사항이 있습니다.')");
            script.println("history.back()"); // 뒤로가기
            script.println("</script>");
        } else {
            UserDAO userDAO = new UserDAO(); //데이터 베이스에 접근 가능한 객체생성
            int result = userDAO.join(user);
            if (result == -1) {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('이미 존재하는 아이디입니다.')");
                script.println("history.back()");
                script.println("</script>");
            } else { // 회원가입이 되었을때 로그인 페이지로 넘어감,-1이 아닌경우 전부 넘어가도록함
            	session.setAttribute("userID", user.getUserID());
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("location.href = 'main.jsp'"); //로그인된 화면
                script.println("</script>");
            }
        }

    %>
</body>
</html>