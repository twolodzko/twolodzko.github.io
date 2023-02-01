import Text.Printf (printf)

data Result t
  = Ok t
  | Err String
  deriving (Show)

fizz :: Integral t => t -> Result t
fizz num | num `mod` 3 == 0 = Err "fizz"
fizz num = Ok $ num + 3

buzz :: Integral t => t -> Result t
buzz num | num `mod` 5 == 0 = Err "buzz"
buzz num = Ok $ num + 5

fizzbuzz :: Integral t => t -> Result t
fizzbuzz num =
  case fizz num of
    Ok val -> buzz num
    Err msg -> Err msg

loop :: Int -> IO ()
loop i | i < 100 = do
  case fizzbuzz i of
    Ok n -> printf "%d => %d\n" i n
    Err msg -> printf "%d => Error: %s\n" i msg
  loop $ i + 1
loop _ = return ()

main :: IO ()
main = loop 1
