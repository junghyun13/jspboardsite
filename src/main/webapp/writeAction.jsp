<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO" %> <!-- bbs 데이터베이스 접근 객체 -->
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!-- 밑의 코드를 써야 내용 받을 수 있음 -->
<!-- 각각의 정보를 가져와 user라는 객체완성 -->
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page" />
<jsp:setProperty name="bbs" property="bbsTitle" />
<jsp:setProperty name="bbs" property="bbsContent" />


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
    <%
        String userID = null; //http://localhost:8095/BBS1/write.jsp
        if(session.getAttribute("userID") != null) { //user가 접속이 되어있다면 세션값이 할당되어 있다면
            userID = (String) session.getAttribute("userID");
        } 
        if (userID == null) { //로그인 안되있으면 로그인하라고 안내
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('로그인을 하세요.')");
            script.println("location.href = 'login.jsp'");
            script.println("</script>");
        } else { // 로그인이 되어있는 사람을 넘김
            //빈공간에 대한 처리, 입력안했을때
            if (bbs.getBbsTitle() == null || bbs.getBbsContent() == null) {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('입력이 안 된 사항이 있습니다.')");
                script.println("history.back()"); // 뒤로가기
                script.println("</script>");
            } else { //빈공간이 아니 실제 입력 받기
                BbsDAO bbsDAO = new BbsDAO(); //데이터 베이스에 접근 가능한 객체생성
                int result = bbsDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent());
                if (result == -1) { // -1일 경우 데이터베이스 오류
                    PrintWriter script = response.getWriter();
                    script.println("<script>");
                    script.println("alert('글쓰기에 실패했습니다.')");
                    script.println("history.back()");
                    script.println("</script>");
                } else { // 입력성공
                    PrintWriter script = response.getWriter();
                    script.println("<script>");
                    script.println("location.href = 'bbs.jsp'");
                    script.println("</script>");
                }
        }
}
%>
</body>
</html>