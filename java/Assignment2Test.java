import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;


public class Assignment2Test {
	
	// A connection to the database  
	  Connection connection;
	  
	  // Statement to run queries
	  Statement sql;
	  
	  // Prepared Statement
	  PreparedStatement ps;
	  
	  // Resultset for the query
	  ResultSet rs;
	  
	  //CONSTRUCTOR
	  Assignment2Test(){
		  try{
			  Class.forName("org.postgresql.Driver");
		  }catch(ClassNotFoundException e){
			  
		  }
	  }
	  
	  //Using the input parameters, establish a connection to be used for this session. Returns true if connection is sucessful
	  public boolean connectDB(String URL, String username, String password){
		  try {
			  connection = DriverManager.getConnection(URL, username, password);
			  String statement = "SET search_path TO A2";
			  sql = connection.createStatement();
			  sql.executeUpdate(statement);		  		  
			  
			  sql.close();
		  }catch (Exception e) {
			// TODO: handle exception
		  }
		  
		  return (connection!=null);
		
	  }
	  
	  //Closes the connection. Returns true if closure was sucessful
	  public boolean disconnectDB(){
		  
		  boolean connectionClosed = false;
		  boolean statementClosed = false;
		  boolean preparedStatementClosed = false;
		  boolean resultSetClosed = false;
		  
		  try{
			  if(rs!=null){
				  rs.close();
				  resultSetClosed = rs.isClosed();
			  }
			  
			  
			  if(ps!=null){
				  ps.close();
				  preparedStatementClosed = ps.isClosed();
			  }
			  
			  
			  if(sql!=null){
				  sql.close();
				  statementClosed = sql.isClosed();
			  }
			  
			  
			  if(connection!=null){
				  connection.close();
				  connectionClosed = connection.isClosed();
			  }
			  

		  }catch(SQLException e){
			  
		  }
		  
	      return (resultSetClosed && preparedStatementClosed && statementClosed && connectionClosed);
	    
	  }
	    
	  public boolean insertCountry (int cid, String name, int height, int population) {	
		  
		  if(connection!=null){
			  boolean psClosed = false;
			  int psReturn = 0;
			  
			  try{
				  String statement = "INSERT INTO country(id, name, height, population) VALUES (?, ?, ?, ?)";
				  ps = connection.prepareStatement(statement);
				  ps.setInt(1, cid);
				  ps.setString(2, name);
				  ps.setInt(3, height);
				  ps.setInt(4, population);
				  psReturn = ps.executeUpdate();
				  ps.close();
				  psClosed = ps.isClosed();
						  
				  
			  }catch(SQLException e){
				  
			  }
			  
			  return (psClosed && (psReturn==1));
		  }
		  return false;
		  
	  }
	  
	  
	  public int getCountriesNextToOceanCount(int oid) {
		  
		  if(connection!=null){
			  boolean psClosed = false;
			  boolean rsClosed = false;
			  int total = 0;
			  
			  try{
				  String statement = "SELECT COUNT(cid) AS number FROM oceanAccess WHERE oid=?";
				  ps = connection.prepareStatement(statement);
				  ps.setInt(1, oid);
				  rs = ps.executeQuery();		  
				  if(rs.next()){
					  total = rs.getInt(1);
					  System.out.println(rs.getInt(1));
				  }
				  if(rs!=null){
					  rs.close();
				  }
				  rsClosed = rs.isClosed();
				  
				  ps.close();
				  psClosed = ps.isClosed(); 				  
				  
			  }catch(SQLException e){
				  
			  }
			  
			  if(rsClosed && psClosed){
				  return total;
			  }else{
				  return -1;
			  }
			  
		  }
		  return -1;

		  
	  }
	   
	  public String getOceanInfo(int oid){
		  
		  if(connection!=null){
			  boolean psClosed = false;
			  boolean rsClosed = false;
			  String info;
			  
			  try{
				  String statement = "SELECT * FROM ocean WHERE oid=?";
				  ps = connection.prepareStatement(statement);
				  ps.setInt(1, oid);
				  rs = ps.executeQuery();		  
				  if(rs.next()){
					  info = rs.getInt(1) + ":" + rs.getString(2) + ":" + rs.getInt(3);
				  }else{
					  info = "";
				  }
				  
				  if(rs!=null){
					  rs.close();
				  }
				  rsClosed = rs.isClosed();
				  
				  ps.close();
				  psClosed = ps.isClosed();
				  
				  return info;
				  
			  }catch(SQLException e){
				  
			  }
		  }
		  return "";
		  
	  }
	  

	  public boolean chgHDI(int cid, int year, float newHDI){
		  
		  if(connection!=null){
			  boolean psClosed = false;
			  int psReturn = 0;
			  
			  try{
				  String statement = "UPDATE hdi SET hdi_score=? WHERE cid=? AND year=?";
				  ps = connection.prepareStatement(statement);
				  ps.setFloat(1, newHDI);
				  psReturn = ps.executeUpdate();		  		  
				  ps.close();		  
				  psClosed = ps.isClosed();
				 
				  
			  }catch(SQLException e){
				  
			  }
			  
			  return (psClosed && (psReturn==1));
		  }
		  return false;
	 
	  }

	  public boolean deleteNeighbour(int c1id, int c2id){
		  
		  if(connection!=null){
			  boolean psClosed = false;
			  int psReturn = 0;
			  
			  try{
				  String statement = "DELETE FROM neighbour WHERE country=? AND neighbor=?";
				  ps = connection.prepareStatement(statement);
				  ps.setInt(1, c1id);
				  ps.setInt(2, c2id);		  
				  psReturn += ps.executeUpdate();
				  
				  ps.setInt(1, c2id);
				  ps.setInt(2, c1id);		  
				  psReturn += ps.executeUpdate();		  
				  
				  ps.close();		  
				  psClosed = ps.isClosed();
				 
				  
			  }catch(SQLException e){
				  
			  }
			  
			  return (psClosed && (psReturn==2));	
		  }
		  return false;
		  
	  }
	  
	  
	  public String listCountryLanguages(int cid){
		  
		  if(connection!=null){
			  boolean psClosed = false;
			  boolean rsClosed = false;
			  String list = "";
			  
			  try{
				  String statement = "SELECT * FROM language WHERE cid=? ORDER BY lpercentage DESC";
				  ps = connection.prepareStatement(statement);
				  ps.setInt(1, cid);
				  rs = ps.executeQuery();		  
				  int i=1;
				  while(rs.next()){
					  list += "|" + i + rs.getInt(2) + ":|" + i + rs.getString(3) + ":|" + i + rs.getDouble(4) + "#";
				  }
				  
				  if(rs!=null){
					  rs.close();
				  }
				  rsClosed = rs.isClosed();
				  
				  ps.close();
				  psClosed = ps.isClosed();
				  
				  return list;
				  
			  }catch(SQLException e){
				  
			  }
		  }
		  return "";

	  }
	  
	  
	  public boolean updateHeight(int cid, int decrH){
		  
		  if(connection!=null){
			  boolean psClosed = false;
			  int psReturn = 0;
			  
			  try{
				  String statement = "UPDATE country SET height=? WHERE cid=?";
				  ps = connection.prepareStatement(statement);
				  ps.setInt(1, decrH);
				  ps.setInt(2, cid);		  
				  psReturn = ps.executeUpdate();		  		  
				  ps.close();		  
				  psClosed = ps.isClosed();
				 
				  
			  }catch(SQLException e){
				  
			  }
			  
			  return (psClosed && (psReturn==1));
		  }
		  return false;
		  
	  }
	    
	  public boolean updateDB(){
		  
		  if(connection!=null){
			  boolean sqlClosed = false;
			  int sqlReturn = 0;
			  
			  try{
				  String statement = "CREATE TABLE mostPopulousCountries AS (SELECT cid,cname FROM country WHERE population>100000000 ORDER BY cid ASC)";
				  sql = connection.createStatement();
				  sqlReturn = sql.executeUpdate(statement);		  		  
				  
				  sql.close();		  
				  sqlClosed = ps.isClosed();
				 
				  
			  }catch(SQLException e){
				  
			  }
			  
			  return (sqlClosed && (sqlReturn!=0));	
		  }
		  return false;
		  
	  }
	

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		Assignment2Test assignment = new Assignment2Test();
		
		if(assignment.connectDB("jdbc:postgresql://localhost:5432/csc343h-c4sousal", "c4sousal", "")){
			System.out.println("Connected");
		}else{
			System.out.println("Didn't connect");
		}
		
		if(assignment.insertCountry(25, "Jamaica", 1000, 1000000)){
			System.out.println("Country inserted");
		}else{
			System.out.println("Country not inserted");
		}
		
		System.out.println(assignment.getOceanInfo(1));
		
		System.out.println(assignment.listCountryLanguages(1));
		
		System.out.println(assignment.getCountriesNextToOceanCount(1));
		
		assignment.disconnectDB();
		

	}

}
