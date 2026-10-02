package com.spms.dao;

import com.spms.model.Deadline;
import java.util.List;

public interface DeadlineDAO {
    void setOrUpdateDeadline(Deadline deadline);
    Deadline getDeadlineBySubject(String subject);
    List<Deadline> findAllDeadlines();
}
