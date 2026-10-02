package com.spms.model;

import org.springframework.format.annotation.DateTimeFormat;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.Date;
import java.util.Objects;

@Entity
@Table(name = "deadlines")
public class Deadline implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @NotNull(message = "Subject cannot be empty")
    @Column(name = "subject", nullable = false, unique = true)
    private String subject;

    @NotNull(message = "Due date cannot be empty")
    @Temporal(TemporalType.TIMESTAMP)
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    @Column(name = "due_date", nullable = false)
    private Date dueDate;

    public Deadline() {
    }

    public Deadline(String subject, Date dueDate) {
        this.subject = subject;
        this.dueDate = dueDate;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Deadline deadline = (Deadline) o;
        return Objects.equals(id, deadline.id) && Objects.equals(subject, deadline.subject);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, subject);
    }

    @Override
    public String toString() {
        return "Deadline{" +
                "id=" + id +
                ", subject='" + subject + '\'' +
                ", dueDate=" + dueDate +
                '}';
    }
}
