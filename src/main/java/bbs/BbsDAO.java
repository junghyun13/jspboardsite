package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public BbsDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS1";
			String dbID = "root";
			String dbPassword = "1213";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public String getDate() {
        String SQL = "SELECT NOW()";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL); //conn객체를 이용 SQL문장을 실행준비로 만듬
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getString(1); //1을해서 현재날짜 그대로 반환
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return ""; //데이터베이스오류
    }

 

    public int getNext() {
        String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC"; // 내림차순하여 가장 마지막에쓰인 글번호              를 가져올 수 있도록함
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL); // conn객체를 이용 SQL문장을 실행준비로 만듬
            rs = pstmt.executeQuery();
            if (rs.next()) {
               return rs.getInt(1) +1; //1을 더해서 그다음 게시글이 들어갈 수 있도록한다.
            }
            return 1; // 현재가 첫번째 게시물인 경우
        } catch(Exception e) {
            e.printStackTrace();
        }
        return -1; //데이터베이스오류
    }

 

    public int write(String bbsTitle, String userID, String bbsContent) {
        String SQL = "INSERT INTO BBS VALUES (?, ?, ?, ?, ?, ?)";// 데이터베이스 코드
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL); //conn객체를 이용, SQL문장을 실행준비로 만듬
            pstmt.setInt(1, getNext());//getNext 다음번에 쓰일 게시글번호
            pstmt.setString(2, bbsTitle);
            pstmt.setString(3, userID);
            pstmt.setString(4, getDate());
            pstmt.setString(5, bbsContent);
            pstmt.setInt(6, 1);//허용상태 글이 있는상태이기 때문에 1
            return pstmt.executeUpdate(); // 성공적으로 수행시 0이상의 값을 반환
            //INSERT는 executeUpdate()로 작동됨
        } catch(Exception e) {
            e.printStackTrace();
        }
        return -1; //데이터베이스오류
    }
    
    public ArrayList<Bbs> getList(int pageNumber) {// 특정한페이지에 다른 게시글 가져올 수 있도록
        String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
        //bbsID가 특정한 숫자보다 작을때, 존재하는글 Available =1, 위에서 10개까지 내림차순
        ArrayList<Bbs> list = new ArrayList<Bbs>(); // Bbs서 나오는 인스턴스 보관
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL); // conn객체를 이용 SQL문장을 실행준비로 만듬
            pstmt.setInt(1, getNext() - (pageNumber -1 ) * 10);//getnext 다음으로 작성될글의 번호
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Bbs bbs = new Bbs();//BBS에 담긴 데이터 가져오기
                bbs.setBbsID(rs.getInt(1));
                bbs.setBbsTitle(rs.getString(2));
                bbs.setUserID(rs.getString(3));
                bbs.setBbsDate(rs.getString(4));
                bbs.setBbsContent(rs.getString(5));
                bbs.setBbsAvailable(rs.getInt(6));
                list.add(bbs);//모든 내용이 담긴 게시글 인스턴스를 리스트에 담아 반환
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public boolean nextPage(int pageNumber) {//다음 페이지가 없을 경우에 대한 처리
        //게시글이 10개일때 pageNumber 1씩 생성, 21개일때는 페이지수 3
            String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1";
            try {
                PreparedStatement pstmt = conn.prepareStatement(SQL); // conn객체를 이용 SQL문장을 실행준비로 만듬
                pstmt.setInt(1, getNext() - (pageNumber -1 ) * 10);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    return true;
                }
            } catch(Exception e) {
                e.printStackTrace();
            }
            return false;
        }
    public Bbs getBbs(int bbsID) {// 특정한 ID에 해당하는 게시글을 가져오도록함
        String SQL = "SELECT * FROM BBS WHERE bbsID = ?"; //bbsID가 특정한 숫자일 경우 진행
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL); // conn객체를 이용 SQL문장을 실행준비로 만듬
            pstmt.setInt(1, bbsID);
            rs = pstmt.executeQuery();
            if (rs.next()) { // 결과가 나왔다면
                Bbs bbs = new Bbs();
                bbs.setBbsID(rs.getInt(1));
                bbs.setBbsTitle(rs.getString(2));
                bbs.setUserID(rs.getString(3));
                bbs.setBbsDate(rs.getString(4));
                bbs.setBbsContent(rs.getString(5));
                bbs.setBbsAvailable(rs.getInt(6));
                return bbs; //정보를 모두 담은 bbs를 리턴 
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null; //해당글이 존재하지 않는경우 null
    }
    public int update(int bbsID, String bbsTitle, String bbsContent) {
        // 특정한 bbsID에 해당하는 제목과 내용을 변경
            String SQL = "UPDATE BBS SET bbsTitle = ?, bbsContent = ? WHERE bbsID = ?";
            try {
                PreparedStatement pstmt = conn.prepareStatement(SQL); // conn객체를 이용 SQL문장을 실행준비로 만듬
                pstmt.setString(1, bbsTitle);
                pstmt.setString(2, bbsContent);
                pstmt.setInt(3, bbsID);
                return pstmt.executeUpdate(); // 성공적으로 수행시 0이상의 값을 반환
            } catch(Exception e) {
                e.printStackTrace();
            }
            return -1; //데이터베이스오류
        }
    public int delete(int bbsID) { // bbsAvailable = 0 하면 삭제처리됨
        String SQL = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID = ?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL); // conn객체를 이용 SQL문장을 실행준비로 만듬
            pstmt.setInt(1, bbsID);
            return pstmt.executeUpdate(); // 성공적으로 수행시 0이상의 값을 반환
        } catch(Exception e) {
            e.printStackTrace();
        }
        return -1; //데이터베이스오류
    }   
}
