using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

[Table("Post", Schema = "dbo")]
public class Post
{
    [Key]
    public int Id { get; set; }

    [Required]
    public string Title { get; set; } = "";

    [Required]
    public string Description { get; set; } = "";

    public DateTime CreatedAt { get; set; }
}