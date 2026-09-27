package model;

import java.io.Serializable;

public class Word implements Serializable {
    private int wordId;
    private String hanzi;
    private String pinyin;
    private String meaningVi;
    private int hskLevel;
    private String topic;
    private String exampleSentence;
    private String exampleMeaningVi;
    private String audioUrl;

    public Word() {
    }

    public Word(int wordId, String hanzi, String pinyin, String meaningVi, int hskLevel, String topic, String exampleSentence, String exampleMeaningVi, String audioUrl) {
        this.wordId = wordId;
        this.hanzi = hanzi;
        this.pinyin = pinyin;
        this.meaningVi = meaningVi;
        this.hskLevel = hskLevel;
        this.topic = topic;
        this.exampleSentence = exampleSentence;
        this.exampleMeaningVi = exampleMeaningVi;
        this.audioUrl = audioUrl;
    }

    public Word(String hanzi, String pinyin, String meaningVi, int hskLevel, String topic, String exampleSentence, String exampleMeaningVi, String audioUrl) {
        this.hanzi = hanzi;
        this.pinyin = pinyin;
        this.meaningVi = meaningVi;
        this.hskLevel = hskLevel;
        this.topic = topic;
        this.exampleSentence = exampleSentence;
        this.exampleMeaningVi = exampleMeaningVi;
        this.audioUrl = audioUrl;
    }

    public int getWordId() {
        return wordId;
    }

    public void setWordId(int wordId) {
        this.wordId = wordId;
    }

    public String getHanzi() {
        return hanzi;
    }

    public void setHanzi(String hanzi) {
        this.hanzi = hanzi;
    }

    public String getPinyin() {
        return pinyin;
    }

    public void setPinyin(String pinyin) {
        this.pinyin = pinyin;
    }

    public String getMeaningVi() {
        return meaningVi;
    }

    public void setMeaningVi(String meaningVi) {
        this.meaningVi = meaningVi;
    }

    public int getHskLevel() {
        return hskLevel;
    }

    public void setHskLevel(int hskLevel) {
        this.hskLevel = hskLevel;
    }

    public String getTopic() {
        return topic;
    }

    public void setTopic(String topic) {
        this.topic = topic;
    }

    public String getExampleSentence() {
        return exampleSentence;
    }

    public void setExampleSentence(String exampleSentence) {
        this.exampleSentence = exampleSentence;
    }

    public String getExampleMeaningVi() {
        return exampleMeaningVi;
    }

    public void setExampleMeaningVi(String exampleMeaningVi) {
        this.exampleMeaningVi = exampleMeaningVi;
    }

    public String getAudioUrl() {
        return audioUrl;
    }

    public void setAudioUrl(String audioUrl) {
        this.audioUrl = audioUrl;
    }
}
