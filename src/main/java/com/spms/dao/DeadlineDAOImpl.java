package com.spms.dao;

import com.spms.model.Deadline;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class DeadlineDAOImpl implements DeadlineDAO {

    @Autowired
    private SessionFactory sessionFactory;

    protected Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public void setOrUpdateDeadline(Deadline deadline) {
        Deadline existing = getDeadlineBySubject(deadline.getSubject());
        if (existing != null) {
            existing.setDueDate(deadline.getDueDate());
            getSession().update(existing);
        } else {
            getSession().save(deadline);
        }
    }

    @Override
    public Deadline getDeadlineBySubject(String subject) {
        Query<Deadline> query = getSession().createQuery(
                "FROM Deadline d WHERE LOWER(d.subject) = LOWER(:subject)", Deadline.class);
        query.setParameter("subject", subject);
        return query.uniqueResultOptional().orElse(null);
    }

    @Override
    public List<Deadline> findAllDeadlines() {
        return getSession().createQuery("FROM Deadline d ORDER BY d.subject ASC", Deadline.class).list();
    }
}
