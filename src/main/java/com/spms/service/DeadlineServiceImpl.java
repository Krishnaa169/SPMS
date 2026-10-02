package com.spms.service;

import com.spms.dao.DeadlineDAO;
import com.spms.model.Deadline;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
@Transactional
public class DeadlineServiceImpl implements DeadlineService {

    @Autowired
    private DeadlineDAO deadlineDAO;

    @Override
    public void setOrUpdateDeadline(Deadline deadline) {
        deadlineDAO.setOrUpdateDeadline(deadline);
    }

    @Override
    public Deadline getDeadlineBySubject(String subject) {
        if (subject == null) return null;
        return deadlineDAO.getDeadlineBySubject(subject.trim());
    }

    @Override
    public boolean isSubmissionAllowed(String subject) {
        if (subject == null) return false;
        Deadline deadline = getDeadlineBySubject(subject.trim());
        if (deadline == null) {
            // If no specific deadline has been configured, submissions are accepted
            return true;
        }
        Date now = new Date();
        return !now.after(deadline.getDueDate());
    }

    @Override
    public List<Deadline> findAllDeadlines() {
        return deadlineDAO.findAllDeadlines();
    }
}
