// Set up the window and display
SetWindowTitle("Snake Game")
SetWindowSize(800, 600, 0)
SetVirtualResolution(40, 30) 			// Grid-based resolution (40x30 tiles)
SetSyncRate(10, 0) 						// 10 FPS for smooth movement

// Snake properties
global snakeX as integer[100] 			// Array for snake X positions
global snakeY as integer[100] 			// Array for snake Y positions
global snakeLength as integer = 3 		// Initial length
global direction as integer = 0 		// 0:right, 1:down, 2:left, 3:up
global foodX as integer 				// Food position X
global foodY as integer 				// Food position Y
global score as integer = 0
global gameOver as integer = 0
global snakeSprite as integer 			// Declare without initialization
global foodSprite as integer 			// Declare without initialization

// Initialize snake starting position
snakeX[0] = 10
snakeY[0] = 10
for i = 1 to snakeLength - 1
    snakeX[i] = snakeX[0] - i
    snakeY[i] = snakeY[0]
next i

// Place initial food
SpawnFood()

// Create sprites for visuals
snakeSprite = CreateSprite(0) 					// Initialize here
SetSpriteColor(snakeSprite, 0, 255, 0, 255) 	// Green snake
SetSpriteSize(snakeSprite, 1, 1) 				// 1x1 tile
foodSprite = CreateSprite(0) 					// Initialize here
SetSpriteColor(foodSprite, 255, 0, 0, 255) 		// Red food
SetSpriteSize(foodSprite, 1, 1)

// Main game loop
do
    if gameOver = 0
        // Handle input
        if GetRawKeyPressed(37) and direction <> 0 
            direction = 2
        elseif GetRawKeyPressed(39) and direction <> 2 
            direction = 0
        elseif GetRawKeyPressed(38) and direction <> 1 
            direction = 3
        elseif GetRawKeyPressed(40) and direction <> 3 
            direction = 1
        endif

        // Move snake
        for i = snakeLength - 1 to 1 step -1
            snakeX[i] = snakeX[i - 1]
            snakeY[i] = snakeY[i - 1]
        next i
        select direction
            case 0: snakeX[0] = snakeX[0] + 1: endcase
            case 1: snakeY[0] = snakeY[0] + 1: endcase
            case 2: snakeX[0] = snakeX[0] - 1: endcase
            case 3: snakeY[0] = snakeY[0] - 1: endcase
        endselect

        // Check boundary collision
        if snakeX[0] < 0 or snakeX[0] >= 40 or snakeY[0] < 0 or snakeY[0] >= 30
            gameOver = 1
        endif

        // Check self collision
        for i = 1 to snakeLength - 1
            if snakeX[0] = snakeX[i] and snakeY[0] = snakeY[i]
                gameOver = 1
            endif
        next i

        // Check food collision
        if snakeX[0] = foodX and snakeY[0] = foodY
            score = score + 10
            snakeLength = snakeLength + 1
            SpawnFood()
        endif

        // Draw snake
        ClearScreen()
        for i = 0 to snakeLength - 1
            SetSpritePosition(snakeSprite, snakeX[i], snakeY[i])
            DrawSprite(snakeSprite)
        next i

        // Draw food
        SetSpritePosition(foodSprite, foodX, foodY)
        DrawSprite(foodSprite)

        // Display score
        Print("Score: " + Str(score))
    else
        // Game over screen
        Print("Game Over! Score: " + Str(score))
        Print("Press Space to Restart")
        if GetRawKeyPressed(32) 
            RestartGame()
        endif
    endif

    Sync()
loop

// Function to spawn food at random position
function SpawnFood()
    local valid as integer
    do
        foodX = Random(0, 39)
        foodY = Random(0, 29)
        valid = 1
        for i = 0 to snakeLength - 1
            if foodX = snakeX[i] and foodY = snakeY[i]
                valid = 0
            endif
        next i
        if valid = 1
            exit // Exit loop if valid position found
        endif
    loop
endfunction

// Function to restart game
function RestartGame()
    snakeLength = 3
    direction = 0
    score = 0
    gameOver = 0
    snakeX[0] = 10
    snakeY[0] = 10
    for i = 1 to snakeLength - 1
        snakeX[i] = snakeX[0] - i
        snakeY[i] = snakeY[0]
    next i
    SpawnFood()
endfunction
