using System.ComponentModel.DataAnnotations;

public class PostInputModel
{
    [Required]
    public string Title { get; set; } = "";

    [Required]
    public string Description { get; set; } = "";
}