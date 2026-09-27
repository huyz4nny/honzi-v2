package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class ImportResultDTO implements Serializable {
    private int totalRows;
    private int insertedCount;
    private int updatedCount;
    private int skippedCount;
    private List<String> updatedWords = new ArrayList<>();
    private List<String> skippedWords = new ArrayList<>();

    public ImportResultDTO() {
    }

    public int getTotalRows() {
        return totalRows;
    }

    public void setTotalRows(int totalRows) {
        this.totalRows = totalRows;
    }

    public int getInsertedCount() {
        return insertedCount;
    }

    public void setInsertedCount(int insertedCount) {
        this.insertedCount = insertedCount;
    }

    public int getUpdatedCount() {
        return updatedCount;
    }

    public void setUpdatedCount(int updatedCount) {
        this.updatedCount = updatedCount;
    }

    public int getSkippedCount() {
        return skippedCount;
    }

    public void setSkippedCount(int skippedCount) {
        this.skippedCount = skippedCount;
    }

    public List<String> getUpdatedWords() {
        return updatedWords;
    }

    public void setUpdatedWords(List<String> updatedWords) {
        this.updatedWords = updatedWords;
    }

    public List<String> getSkippedWords() {
        return skippedWords;
    }

    public void setSkippedWords(List<String> skippedWords) {
        this.skippedWords = skippedWords;
    }
}
