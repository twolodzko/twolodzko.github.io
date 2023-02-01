import Text.Printf (printf)

data Result t
  = Ok t
  | Err String
  deriving (Show)

(?>) :: Result t -> (t -> Result t) -> Result t
(?>) (Ok x) f = f x
(?>) (Err msg) _ = Err msg

fizz :: Integral t => t -> Result t
fizz num | num `mod` 3 == 0 = Err "fizz"
fizz num = Ok $ num + 3

buzz :: Integral t => t -> Result t
buzz num | num `mod` 5 == 0 = Err "buzz"
buzz num = Ok $ num + 5

fuzzbuzz :: Integral t => t -> Result t
fuzzbuzz num = fizz num ?> buzz

loop :: Int -> IO ()
loop i | i < 100 = do
  case fuzzbuzz i of
    Ok n -> printf "%d => %d\n" i n
    Err msg -> printf "%d => Error: %s\n" i msg
  loop $ i + 1
loop _ = return ()

main :: IO ()
main = loop 1
