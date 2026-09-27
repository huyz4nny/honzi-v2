using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HonZi.Web.Models
{
    [Table("QuizResults")]
    public class QuizResult
    {
        [Key]
        [Column("QuizID")]
        public int QuizId { get; set; }

        [Column("UserID")]
        public int UserId { get; set; }

        public int HskLevel { get; set; }

        public int Score { get; set; }

        public int TotalQuestions { get; set; } = 10;

        public DateTime TakenAt { get; set; } = DateTime.Now;

        // Foreign keys
        [ForeignKey("UserId")]
        public virtual User User { get; set; } = null!;
    }
}
