using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HonZi.Web.Models
{
    [Table("UserProgress")]
    public class UserProgress
    {
        [Key]
        [Column("ProgressID")]
        public int ProgressId { get; set; }

        [Column("UserID")]
        public int UserId { get; set; }

        [Column("WordID")]
        public int WordId { get; set; }

        [Required]
        [MaxLength(20)]
        public string Status { get; set; } = "New"; // "New", "Learning", "Mastered"

        public int CorrectCount { get; set; } = 0;

        public int WrongCount { get; set; } = 0;

        public DateTime? LastReviewedAt { get; set; } = DateTime.Now;

        public DateTime? NextReviewAt { get; set; }

        // Foreign keys
        [ForeignKey("UserId")]
        public virtual User User { get; set; } = null!;

        [ForeignKey("WordId")]
        public virtual Word Word { get; set; } = null!;
    }
}
