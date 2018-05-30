package org.joywins.domain;
import java.util.Arrays;
//...174p.
import java.util.Date;
/***
 * create table ZTBL_BOARD
(
	BNO	int not null auto_increment
    ,TITLE	varchar(200) not null
    ,CONTENT text null
    ,WRITER	varchar(50) not null
    ,REGDATE	timestamp not null	default	now()
    #,UPDATEDATE	timestamp	default	now()
    ,VIEW_COUNT	int default 0
    ,primary key(BNO)
);


CREATE TABLE `ztbl_attach` (
  `FULL_NAME` varchar(150) NOT NULL,
  `BNO` int(11) NOT NULL,
  `REGDATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`FULL_NAME`)
);

alter table ztbl_attach
		add constraint fk_board_attach
        foreign key(bno) references ztbl_board(bno);


 * @author Administrator
 *
 */
public class BoardVO {

	private Integer bno;
	private String title;
	private String content;
	private String writer;
	private Date regdate;
	private int view_count;
	private int reply_count;

	private String[] files; //...586p.첨부파일들...

	public Integer getBno() {
		return bno;
	}

	public void setBno(Integer bno) {
		this.bno = bno;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getWriter() {
		return writer;
	}

	public void setWriter(String writer) {
		this.writer = writer;
	}

	public Date getRegdate() {
		return regdate;
	}

	public void setRegdate(Date regdate) {
		this.regdate = regdate;
	}

	public int getView_count() {
		return view_count;
	}

	public void setView_count(int view_count) {
		this.view_count = view_count;
	}

	public int getReply_count() {
		return reply_count;
	}

	public void setReply_count(int reply_count) {
		this.reply_count = reply_count;
	}

	public String[] getFiles() {
		return files;
	}

	public void setFiles(String[] files) {
		this.files = files;
	}

	@Override
	public String toString() {
		return "BoardVO [bno=" + bno 
				   + ", title=" + title 
				   + ", content=" + content 
				   + ", writer=" + writer 
				   + ", regdate=" + regdate 
				   + ", view_count=" + view_count 
				   + ", reply_count=" + reply_count 
				   + ", files=" + Arrays.toString(files) + "]";
	}

}
