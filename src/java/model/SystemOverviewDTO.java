package model;

import java.io.Serializable;

public class SystemOverviewDTO implements Serializable {
    private int totalUsers;
    private int totalWords;
    private int totalMasteredWords;
    private int totalQuizzesTaken;

    public SystemOverviewDTO() {
    }

    public SystemOverviewDTO(int totalUsers, int totalWords, int totalMasteredWords, int totalQuizzesTaken) {
        this.totalUsers = totalUsers;
        this.totalWords = totalWords;
        this.totalMasteredWords = totalMasteredWords;
        this.totalQuizzesTaken = totalQuizzesTaken;
    }

    public int getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(int totalUsers) {
        this.totalUsers = totalUsers;
    }

    public int getTotalWords() {
        return totalWords;
    }

    public void setTotalWords(int totalWords) {
        this.totalWords = totalWords;
    }

    public int getTotalMasteredWords() {
        return totalMasteredWords;
    }

    public void setTotalMasteredWords(int totalMasteredWords) {
        this.totalMasteredWords = totalMasteredWords;
    }

    public int getTotalQuizzesTaken() {
        return totalQuizzesTaken;
    }

    public void setTotalQuizzesTaken(int totalQuizzesTaken) {
        this.totalQuizzesTaken = totalQuizzesTaken;
    }
}
