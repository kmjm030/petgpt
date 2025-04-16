package com.mc.app.service;

import com.mc.app.dto.AdminComments;
import com.mc.app.frame.MCService;
import com.mc.app.repository.AdminCommentsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminCommentsService implements MCService<AdminComments, Integer> {

    private final AdminCommentsRepository adminCommentsRepository;

    @Override
    public void add(AdminComments adminComments) throws Exception {
        adminCommentsRepository.insert(adminComments);
    }

    @Override
    public void mod(AdminComments adminComments) throws Exception {
        adminCommentsRepository.update(adminComments);
    }

    @Override
    public void del(Integer adminCommentsKey) throws Exception {
        adminCommentsRepository.delete(adminCommentsKey);
    }

    @Override
    public AdminComments get(Integer boardKey) throws Exception {
        return adminCommentsRepository.selectOne(boardKey);
    }

    @Override
    public List<AdminComments> get() throws Exception {
        return adminCommentsRepository.select();
    }

//    public List<AdminComments> selectAllbyItem(Integer itemKey) throws Exception {
//        return adminCommentsRepository.selectAllbyItem(itemKey);
//    }

    // 로그인 전용 메서드
//    public AdminComments login(String id, String pwd) throws Exception {
//        AdminComments AdminComments = AdminCommentsRepository.select(id);
//        if (AdminComments != null && AdminComments.getAdminCommentsPwd().equals(pwd)) {
//            return AdminComments;
//        }
//        return null;
//    }

//    public void saveOrUpdateComment(AdminComments comment) {
//        AdminComments existing = adminCommentsRepository.getCommentByBoardKey(comment.getBoardKey());
//        if (existing == null) {
//            adminCommentsRepository.insertAdminComment(comment);
//        } else {
//            comment.setAdcommentsKey(existing.getAdcommentsKey());
//            adminCommentsRepository.updateAdminComment(comment);
//        }
//    }

//    public AdminComments getComment(int boardKey) {
//        return adminCommentsRepository.getCommentByBoardKey(boardKey);
//    }
}

