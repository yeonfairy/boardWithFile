package com.spring.board.board.controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.google.gson.JsonObject;
import com.spring.board.board.model.service.BoardService;
import com.spring.board.board.model.vo.Board;

@Controller
public class BoardController {
	
	private static Logger logger = LoggerFactory.getLogger(BoardController.class);
	@Autowired
	private BoardService bService;

	@RequestMapping("board.do")
	public String boardView(Model model, Board boardVo) throws Exception{

		ArrayList<Board> bList = bService.selectBoardList();
		model.addAttribute("bList", bList);
		List<Map<String, Object>> fileList = bService.selectFileList(boardVo.getBoardNo());
		model.addAttribute("file", fileList);

		return "board/boardView";
	}
	
	//첨부파일 다운로드
	@RequestMapping(value="fileDown.do")
	public String fileDown(@RequestParam int boardNo, HttpServletResponse response) throws Exception{
		//System.out.println("fileDown.fileDown::::::::::::::::::::::::::::::::::"+request.getParameter("boardNo"));

		Map<String, Object> resultMap  = bService.selectFileInfo(boardNo);
		if(resultMap != null) {

		String storedFileName = (String) resultMap.get("STORED_FILE_NAME");
		String originalFileName = (String) resultMap.get("ORG_FILE_NAME");
		// 파일을 저장했던 위치에서 첨부파일을 읽어 byte[]형식으로 변환한다.
		byte fileByte[] = org.apache.commons.io.FileUtils.readFileToByteArray(new File("C:\\work\\upload\\"+originalFileName));
		
		response.setContentType("application/java-archive"); //jar파일로 다운로드
		response.setContentType("application/octet-stream"); // 다운로드시 다른이름으로 저장이 뜨도록 설정
		response.setContentLength(fileByte.length);
		response.setHeader("Content-Disposition",  "attachment; fileName=\""+URLEncoder.encode(originalFileName, "UTF-8")+"\";");
		response.getOutputStream().write(fileByte);
		response.getOutputStream().flush();
		response.getOutputStream().close();
		} else {
			return "board/boardDetail";
		}
		return "board/boardDetail";
	}

	@RequestMapping(value = "insertForm.do", method = RequestMethod.GET)
	public String boardInsertView() {

		return "board/boardInsert";
	}
	
	@RequestMapping(value = "sendMailForm.do", method = RequestMethod.GET)
	public String sendMailFormView() {

		return "board/mailForm";
	}

	@RequestMapping(value = "sendMail.do", method = RequestMethod.POST)
	public String sendMailView() {

		return "board/sendMail";
	}
	
	@RequestMapping("inputPwd.do")
	public String boardPwdInpur() {
		return "board/pwdSetting";
	}

	@RequestMapping(value = "boardInsert.do", method = RequestMethod.POST)
	public String boardInsert(Board board, MultipartHttpServletRequest mpRequest) throws Exception {
		System.out.println("boardInsert.boardInsert::::::::::::::::::::::::::::::::::"+board);

	    bService.insertBoard(board, mpRequest);
	      System.out.println("저장이 성공적--------------------");

		return "redirect:board.do";
	
	}
	
	@RequestMapping(value = "deleteBoard.do", method = RequestMethod.POST)
	public String deletingBoard(@RequestParam int boardNo) throws Exception {
		System.out.println("deleteBoard.deleteBoard::::::::::::::::::::::::::::::::::"+boardNo);

	    bService.deleteBoard(boardNo);
	      System.out.println("저장이 삭제--------------------");

			return "redirect:board.do";
	
	}
	
	@RequestMapping(value = "updateForm.do")
	public String boardUpdateView(Board board, Model model, HttpServletRequest request, MultipartHttpServletRequest mpRequest) throws Exception {
		System.out.println("접속=================시작");
		int id = Integer.parseInt(request.getParameter("boardNo"));
		board = bService.selectBoardOne(id);
		model.addAttribute("boardNo", id);
		model.addAttribute("board", board);
		
		List<Map<String, Object>> fileList = bService.selectFileList(id);
		model.addAttribute("file", fileList);
		System.out.println("접속=================끝");		
		
	    bService.updateBoard(board, mpRequest);
	    System.out.println("저장이 성공적--------------------");
		return "board/boardUpdate";
	}
	
	@RequestMapping(value = "updateBoardSave.do")
	public String updateBoardSave(Board board, MultipartHttpServletRequest mpRequest) throws Exception {
		System.out.println("업로드접속=================시작");
	    bService.updateBoard(board, mpRequest);
		System.out.println("접속=================끝");
		return "redirect:board.do";
	}
	
	@RequestMapping(value="uploadImage.do", produces = "application/json")
	@ResponseBody
	public JsonObject uploadSummernoteImageFile(@RequestParam("file") MultipartFile multipartFile) throws Exception {

		JsonObject jsonObject = new JsonObject();
		
		String fileRoot = "C:\\summernote_image\\";	//저장될 외부 파일 경로
		String originalFileName = multipartFile.getOriginalFilename();	//오리지날 파일명
		String extension = originalFileName.substring(originalFileName.lastIndexOf("."));	//파일 확장자
				
		String savedFileName = UUID.randomUUID() + extension;	//저장될 파일 명
		
		File targetFile = new File(fileRoot + originalFileName);	
		
		try {
			InputStream fileStream = multipartFile.getInputStream();
			FileUtils.copyInputStreamToFile(fileStream, targetFile);	//파일 저장
			jsonObject.addProperty("url", "/summernoteImage/"+savedFileName);
		
			jsonObject.addProperty("responseCode", "success");
				
		} catch (IOException e) {
			FileUtils.deleteQuietly(targetFile);	//저장된 파일 삭제
			jsonObject.addProperty("responseCode", "error");
			e.printStackTrace();
		}
		
		return jsonObject;
	}


	@RequestMapping("boardDetail.do")
	public String boardDetail(int bNo, String inputPwd, Model model, Board boardVo, HttpServletRequest request) throws Exception{
		Board board = bService.selectBoardOne(bNo);
		String id = request.getParameter("bNo");

		model.addAttribute("board", board);
		List<Map<String, Object>> fileList = bService.selectFileList(bNo);
		model.addAttribute("file", fileList);
		
		ArrayList<Board> bList = bService.selectBoardList();
		model.addAttribute("bList", bList);
		return "board/boardDetail";
	}

	@RequestMapping("checkPwd.do")
	public String checkingPwd(int bNo, Model model) {
		model.addAttribute("bNo", bNo);

		return "board/pwdChecking";
	}

	@ResponseBody
	@RequestMapping("checkcheck.do")
	public String checkcheck(String pwd, int bNo) {
		int result = bService.selectBoardPwd(new Board(bNo, pwd));


		return result + "";
	}

	@ResponseBody
	@RequestMapping("settingpwd.do")
	public String settingPwd(String pwd, int bNo) {
		int result = bService.updateBoardPwd(new Board(bNo, pwd));
		return result + "";
	}
}