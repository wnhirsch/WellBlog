using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using Microsoft.Data.SqlClient;


namespace WellBlog.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PostsController : ControllerBase
    {
        private readonly DatabaseContext _dbContext;

        public PostsController(DatabaseContext dbContext)
        {
            _dbContext = dbContext;
        }

        [HttpGet("{id}")]
        public ActionResult Get(int id)
        {
            Console.WriteLine($"- [GET, Post, id = {id}]: Starting...");

            try {
                var post = _dbContext.Posts.FirstOrDefault(p => p.Id == id);
                if (post == null)
                {
                    Console.WriteLine($"- [GET, Post, id = {id}]: Not Found!");
                    return NotFound();
                }
                
                Console.WriteLine($"- [GET, Post, id = {id}]: Success!");
                return Ok(post);
            }
            catch (SqlException ex)
            {
                Console.WriteLine($"- [GET, Post, id = {id}]: Error occurred in the application.");
                Console.WriteLine(ex.Message);
                return StatusCode(StatusCodes.Status500InternalServerError, "An error occurred while processing the request.");
            }

        }

        [HttpGet]
        public ActionResult Get(int page = 1, int pageSize = 10)
        {
            Console.WriteLine($"- [GET, Post, page = {page}, pageSize = {pageSize}]: Starting...");

            try
            {
                var posts = _dbContext.Posts
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .ToList();

                Console.WriteLine($"- [GET, Post, page = {page}, pageSize = {pageSize}]: Success!");
                return Ok(posts);
            }
            catch (SqlException ex)
            {
                Console.WriteLine($"- [GET, Post, page = {page}, pageSize = {pageSize}]: Error connecting to the database.");
                Console.WriteLine(ex.Message);
                return StatusCode(StatusCodes.Status500InternalServerError, "An error occurred while processing the request.");
            }
        }


        [HttpPost]
        public ActionResult Post([FromBody] PostInputModel model)
        {
            Console.WriteLine("- [POST, Post]: Starting...");

            if (ModelState.IsValid)
            {
                var post = new Post
                {
                    Title = model.Title,
                    Description = model.Description,
                    CreatedAt = DateTime.UtcNow
                };

                try
                {
                    _dbContext.Posts.Add(post);
                    _dbContext.SaveChanges();

                    Console.WriteLine("- [POST, Post]: Success!");
                    return NoContent();
                }
                catch (DbUpdateException ex)
                {
                    Console.WriteLine("- [POST, Post]: Error occurred while saving changes to the database.");
                    Console.WriteLine(ex.Message);
                    return StatusCode(StatusCodes.Status500InternalServerError, "An error occurred while processing the request.");
                }
                catch (Exception ex)
                {
                    Console.WriteLine("- [POST, Post]: Error occurred in the application.");
                    Console.WriteLine(ex.Message);
                    return StatusCode(StatusCodes.Status500InternalServerError, "An error occurred while processing the request.");
                }
            } 
            else 
            {
                Console.WriteLine("[- POST, Post]: Bad Request: Model invalid.");
                return BadRequest(ModelState);
            }
        }

        [HttpDelete("{id}")]
        public ActionResult Delete(int id)
        {
            Console.WriteLine($"- [DELETE, Post, id = {id}]: Starting...");

            try
            {
                var post = _dbContext.Posts.FirstOrDefault(p => p.Id == id);
                if (post == null)
                {
                    Console.WriteLine($"- [DELETE, Post, id = {id}]: Not Found!");
                    return BadRequest();
                }

                _dbContext.Posts.Remove(post);
                _dbContext.SaveChanges();

                Console.WriteLine($"- [DELETE, Post, id = {id}]: Success!");
                return NoContent();
            }
            catch (DbUpdateException ex)
            {
                Console.WriteLine($"- [DELETE, Post, id = {id}]: Error occurred while saving changes to the database.");
                Console.WriteLine(ex.Message);
                return StatusCode(StatusCodes.Status500InternalServerError, "An error occurred while processing the request.");
            }
            catch (SqlException ex)
            {
                Console.WriteLine($"- [DELETE, Post, id = {id}]: Error occurred in the application.");
                Console.WriteLine(ex.Message);
                return StatusCode(StatusCodes.Status500InternalServerError, "An error occurred while processing the request.");
            }
        }
    }
}