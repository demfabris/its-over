# Common Rust Errors

## Borrow Checker Errors

### E0502: Cannot borrow as mutable because also borrowed as immutable

```rust
// Problem
let mut v = vec![1, 2, 3];
let first = &v[0];      // immutable borrow
v.push(4);              // mutable borrow - ERROR!
println!("{}", first);

// Solution 1: Scope the immutable borrow
let mut v = vec![1, 2, 3];
{
    let first = &v[0];
    println!("{}", first);
}  // immutable borrow ends
v.push(4);

// Solution 2: Clone if cheap
let mut v = vec![1, 2, 3];
let first = v[0];  // Copy, not borrow
v.push(4);
```

### E0382: Use of moved value

```rust
// Problem
let s = String::from("hello");
let s2 = s;           // s moved to s2
println!("{}", s);    // ERROR: s was moved

// Solution 1: Clone
let s = String::from("hello");
let s2 = s.clone();
println!("{}", s);    // OK

// Solution 2: Use references
let s = String::from("hello");
let s2 = &s;
println!("{}", s);    // OK
```

### E0499: Cannot borrow as mutable more than once

```rust
// Problem
let mut s = String::from("hello");
let r1 = &mut s;
let r2 = &mut s;  // ERROR!

// Solution: Scope your borrows
let mut s = String::from("hello");
{
    let r1 = &mut s;
    r1.push_str(" world");
}  // r1 goes out of scope
let r2 = &mut s;  // OK now
```

## Lifetime Errors

### E0106: Missing lifetime specifier

```rust
// Problem
fn longest(x: &str, y: &str) -> &str {  // ERROR
    if x.len() > y.len() { x } else { y }
}

// Solution: Add lifetime annotation
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() { x } else { y }
}
```

### Struct lifetime

```rust
// Problem
struct Excerpt {
    part: &str,  // ERROR: missing lifetime
}

// Solution
struct Excerpt<'a> {
    part: &'a str,
}
```

## Async/Tokio Gotchas

### Future not Send

```rust
// Problem: Rc is not Send
use std::rc::Rc;
async fn broken() {
    let rc = Rc::new(5);
    tokio::spawn(async move {
        println!("{}", rc);  // ERROR: Rc not Send
    });
}

// Solution: Use Arc
use std::sync::Arc;
async fn fixed() {
    let arc = Arc::new(5);
    tokio::spawn(async move {
        println!("{}", arc);  // OK
    });
}
```

### Blocking in async context

```rust
// Problem: std::thread::sleep blocks the runtime
async fn bad() {
    std::thread::sleep(Duration::from_secs(1));  // BLOCKS!
}

// Solution: Use tokio::time::sleep
async fn good() {
    tokio::time::sleep(Duration::from_secs(1)).await;
}

// Or spawn_blocking for CPU-intensive work
async fn cpu_work() {
    tokio::task::spawn_blocking(|| {
        // Heavy computation here
    }).await.unwrap();
}
```

### Missing .await

```rust
// Problem: Forgot .await
async fn fetch_data() -> Data { ... }

let future = fetch_data();  // This is a Future, not Data!
// process(future);  // Wrong type!

// Solution: Await it
let data = fetch_data().await;  // Now it's Data
process(data);  // Correct!
```

## Serde Errors

### Missing derive

```rust
// Problem
struct Config {
    name: String,
}
serde_json::from_str::<Config>(json)?;  // ERROR

// Solution: Add derives
#[derive(Deserialize)]
struct Config {
    name: String,
}
```

### Field name mismatch

```rust
// Problem: JSON has "userName" but struct has "user_name"
#[derive(Deserialize)]
struct User {
    user_name: String,  // Won't match!
}

// Solution: Rename
#[derive(Deserialize)]
struct User {
    #[serde(rename = "userName")]
    user_name: String,
}

// Or use rename_all
#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
struct User {
    user_name: String,  // Matches "userName"
}
```

### Optional fields

```rust
// Problem: Field missing in JSON
#[derive(Deserialize)]
struct Config {
    required: String,
    optional: String,  // ERROR if missing!
}

// Solution: Use Option
#[derive(Deserialize)]
struct Config {
    required: String,
    optional: Option<String>,  // OK if missing
}

// Or provide default
#[derive(Deserialize)]
struct Config {
    required: String,
    #[serde(default)]
    optional: String,  // Empty string if missing
}
```

## Type Inference Issues

### Cannot infer type

```rust
// Problem
let v = Vec::new();  // ERROR: cannot infer type

// Solution 1: Annotate
let v: Vec<i32> = Vec::new();

// Solution 2: Turbofish
let v = Vec::<i32>::new();

// Solution 3: Let usage infer
let mut v = Vec::new();
v.push(1i32);  // Now it knows it's Vec<i32>
```
