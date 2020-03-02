package com.spring.board.board.controller;

import java.io.File;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.LogManager;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.spring.board.board.model.service.BoardService;
import com.spring.board.board.model.vo.Board;

@Controller
public class BoardController {

	@Autowired
	private BoardService bService;

	@RequestMapping("board.do")
	public String boardView(Model model, Board boardVo) throws Exception{

		ArrayList<Board> bList = bService.selectBoardList();
		System.out.println(bList);

		model.addAttribute("bList", bList);
		
		List<Map<String, Object>> fileList = bService.selectFileList(boardVo.getBoardNo());
		model.addAttribute("file", fileList);


		return "board/boardView";
	}
	
	//첨부파일 다운로드
	@RequestMapping(value="fileDown.do")
	public void fileDown(@RequestParam Map<String, Object> map, HttpServletResponse response, Integer bNo) throws Exception{
		int boardNo = (bNo == null) ? 1 : bNo;
		Board board = bService.selectBoardOne(boardNo);

		Map<String, Object> resultMap = bService.selectFileInfo(map);
		
		String storedFileName = (String) resultMap.get("STORED_FILE_NAME");
		String originalFileName = (String) resultMap.get("ORG_FILE_NAME");
		
		// 파일을 저장했던 위치에서 첨부파일을 읽어 byte[]형식으로 변환한다.
		byte fileByte[] = org.apache.commons.io.FileUtils.readFileToByteArray(new File("C:\\work\\upload\\"+storedFileName));
		
		response.setContentType("application/octet-stream");
		response.setContentLength(fileByte.length);
		response.setHeader("Content-Disposition",  "attachment; fileName=\""+URLEncoder.encode(originalFileName, "UTF-8")+"\";");
		response.getOutputStream().write(fileByte);
		response.getOutputStream().flush();
		response.getOutputStream().close();
	} 
	

	
	@RequestMapping(value = "insertForm.do", method = RequestMethod.GET)
	public String boardInsertView() {

		return "board/boardInsert";
	}

	@RequestMapping("inputPwd.do")
	public String boardPwdInpur() {
		return "board/pwdSetting";
	}

	@RequestMapping(value = "boardInsert.do", method = RequestMethod.POST)
	public String boardInsert(Board board, MultipartHttpServletRequest mpRequest) throws Exception {
		System.out.println(board);

	    bService.insertBoard(board, mpRequest);

		return "redirect:board.do";
	
	}

	@RequestMapping("boardDetail.do")
	public String boardDetail(Integer bNo, String inputPwd, Model model, Board boardVo) throws Exception{
		int boardNo = (bNo == null) ? 1 : bNo;
		Board board = bService.selectBoardOne(boardNo);
		model.addAttribute("board", board);
		List<Map<String, Object>> fileList = bService.selectFileList(boardVo.getBoardNo());
		model.addAttribute("file", fileList);
		
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