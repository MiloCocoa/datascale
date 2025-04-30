from mcp.server.fastmcp import FastMCP

# Create an MCP server
mcp = FastMCP("demo")


# Add an addition tool
@mcp.tool()
def add(a: int, b: int) -> int:
    """Add two numbers"""
    return a + b


@mcp.tool()
def count_r(word: str) -> int:
    """Count the number of 'r' letters in a given word."""
    try:
        return word.lower().count("r")
    except Exception as e:
        # Return 0 on any error
        return 0


if __name__ == "__main__":
    mcp.run(transport='stdio')
