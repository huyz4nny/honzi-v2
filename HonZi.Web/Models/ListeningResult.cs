using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HonZi.Web.Models
{
    [Table("ListeningResults")]
    public class ListeningResult
    {
        [Key]
        [Column("ListeningID")]
        public int ListeningId { get; set; }

        [Column("UserID")]
        public int UserId { get; set; }

        public int HskLevel { get; set; }

        [Required]
        [MaxLength(50)]
        public string ExerciseType { get; set; } = "Word"; // "Word" hoặc "Sentence"

        [Required]
        [MaxLength(50)]
        public string InputMode { get; set; } = "Hanzi"; // "Hanzi" hoặc "Pinyin"

        public int Score { get; set; }

        public int TotalQuestions { get; set; } = 10;

        public double AccuracyPercentage { get; set; }

        public DateTime TakenAt { get; set; } = DateTime.Now;

        // Foreign keys
        [ForeignKey("UserId")]
        public virtual User User { get; set; } = null!;
    }
}
