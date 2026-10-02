package com.spms.service;

import com.spms.model.Deadline;
import java.util.List;

public interface DeadlineService {
    void setOrUpdateDeadline(Deadline deadline);
    Deadline getDeadlineBySubject(String subject);
    boolean isSubmissionAllowed(String subject);
    List<Deadline> findAllDeadlines();
}
