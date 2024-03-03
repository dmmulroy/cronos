type date = {
  year : int;
  month : int;
  day : int;
  hour : int;
  minute : int;
  second : int;
  offset_hours : int;
  offset_minutes : int;
}

type format
type error = Invalid_date

module Constants = struct
  (** Collection of useful date constants. *)

  (** Days in 1 week. *)
  let days_in_week = 7

  (** Days in 1 year.
    
    One year equals 365.2425 days according to the formula:
    
    - Leap year occurs every 4 years, except for years that are divisible by 100 and not divisible by 400.
    - 1 mean year = (365 + 1/4 - 1/100 + 1/400) days = 365.2425 days *)
  let days_in_year = 365.2425

  (** Maximum allowed time in milliseconds.

    This value represents the highest number of milliseconds that can be
    accurately represented and manipulated within the limitations of the IEEE 
    754 double-precision floating-point format, ensuring date and time 
    calculations remain precise and reliable for both OCaml and JavaScript 
    (via Melange or JSOO) runtimes.

    The value corresponds to a time approximately 285,616 years after the
    Unix epoch (January 1, 1970), marking a practical limit for time-related
    operations.

    Example usage:
    {[
      let is_valid = 8640000000000001 <= max_time
      (* => false *)

      (* Attempting to represent a time beyond this limit may lead to
         precision loss or undefined behavior. *)
      (* Date.of_milliseconds 8640000000000001 *)
      (* => Invalid_date *)
    ]}
*)
  let max_time_in_milliseconds = 8640000000000000

  (** Minimum allowed time in milliseconds.

    This value represents the lowers number of milliseconds that can be
    accurately represented and manipulated within the limitations of the IEEE 
    754 double-precision floating-point format, ensuring date and time 
    calculations remain precise and reliable for both OCaml and JavaScript 
    (via Melange or JSOO) runtimes.

    The value corresponds to a time approximately 285,616 years before the
    Unix epoch (January 1, 1970), marking a practical limit for time-related
    operations.

    Example usage:
    {[
      let is_valid = -8640000000000001 >= min_time_in_milliseconds
      (* => false *)

      (* Attempting to represent a time beyond this limit may lead to
         precision loss or undefined behavior. *)
      (* Date.of_milliseconds -8640000000000001 *)
      (* => Invalid_date *)
    ]}
*)
  let min_time = -max_time_in_milliseconds

  (** Minutes in 1 year. *)
  let minutes_in_year = 525600

  (** Minutes in 1 month. *)
  let minutes_in_month = 43200

  (** Minutes in 1 day. *)
  let minutes_in_day = 1440

  (** Minutes in 1 hour. *)
  let minutes_in_hour = 60

  (** Months in 1 quarter. *)
  let months_in_quarter = 3

  (** Months in 1 year. *)
  let months_in_year = 12

  (** Quarters in 1 year *)
  let quarters_in_year = 4

  (** Seconds in 1 hour. *)
  let seconds_in_hour = 3600

  (** Seconds in 1 minute. *)
  let seconds_in_minute = 60

  (** Seconds in 1 day. *)
  let seconds_in_day = seconds_in_hour * 24

  (** Seconds in 1 week. *)
  let seconds_in_week = seconds_in_day * 7

  (** Seconds in 1 year. *)
  let seconds_in_year =
    int_of_float (float_of_int seconds_in_day *. days_in_year)
  ;;

  (** Seconds in 1 month *)
  let seconds_in_month = seconds_in_year / 12

  (** Seconds in 1 quarter. *)
  let seconds_in_quarter = seconds_in_month * 3

  (** Milliseconds in 1 year. *)
  let milliseconds_in_year = seconds_in_year * 1000

  let milliseconds_in_month = seconds_in_month * 1000

  (** Milliseconds in 1 week. *)
  let milliseconds_in_week = 604800000

  (** Milliseconds in 1 day. *)
  let milliseconds_in_day = 86400000

  (** Milliseconds in 1 minute *)
  let milliseconds_in_minute = 60000

  (** Milliseconds in 1 hour *)
  let milliseconds_in_hour = 3600000

  (** Milliseconds in 1 second *)
  let milliseconds_in_second = 1000
end

module Duration = struct
  type t = {
    milliseconds : int option;
    seconds : int option;
    minutes : int option;
    hours : int option;
    days : int option;
    months : int option;
    years : int option;
  }

  let make ?milliseconds ?seconds ?minutes ?hours ?days ?months ?years () =
    { milliseconds; seconds; minutes; hours; days; months; years }
  ;;

  let of_milliseconds milliseconds =
    let years =
      Float.(
        to_int
          (floor (of_int milliseconds /. of_int Constants.milliseconds_in_year)))
    in
    let milliseconds =
      milliseconds - (Constants.milliseconds_in_year * years)
    in

    let months =
      Float.(
        to_int
          (floor
             (of_int milliseconds /. of_int Constants.milliseconds_in_month)))
    in
    let milliseconds =
      milliseconds - (Constants.milliseconds_in_month * months)
    in

    let days =
      Float.(
        to_int
          (floor (of_int milliseconds /. of_int Constants.milliseconds_in_day)))
    in
    let milliseconds = milliseconds - (Constants.milliseconds_in_day * days) in

    let hours =
      Float.(
        to_int
          (floor (of_int milliseconds /. of_int Constants.milliseconds_in_hour)))
    in
    let milliseconds =
      milliseconds - (Constants.milliseconds_in_hour * hours)
    in

    let hours =
      Float.(
        to_int
          (floor (of_int milliseconds /. of_int Constants.milliseconds_in_hour)))
    in
    let milliseconds =
      milliseconds - (Constants.milliseconds_in_hour * hours)
    in

    let minutes =
      Float.(
        to_int
          (floor
             (of_int milliseconds /. of_int Constants.milliseconds_in_minute)))
    in
    let milliseconds =
      milliseconds - (Constants.milliseconds_in_minute * minutes)
    in

    let seconds =
      Float.(
        to_int
          (floor
             (of_int milliseconds /. of_int Constants.milliseconds_in_second)))
    in
    let milliseconds =
      milliseconds - (Constants.milliseconds_in_second * seconds)
    in

    make ~years ~months ~days ~hours ~minutes ~seconds ~milliseconds ()
  ;;

  let to_milliseconds
      { years; months; days; hours; minutes; seconds; milliseconds } =
    let years_ms =
      years
      |> Option.fold
           ~some:(fun years -> years * Constants.milliseconds_in_year)
           ~none:0
    in
    let months_ms =
      months
      |> Option.fold
           ~some:(fun months -> months * Constants.milliseconds_in_month)
           ~none:0
    in
    let days_ms =
      days
      |> Option.fold
           ~some:(fun days -> days * Constants.milliseconds_in_day)
           ~none:0
    in
    let hours_ms =
      hours
      |> Option.fold
           ~some:(fun hours -> hours * Constants.milliseconds_in_hour)
           ~none:0
    in
    let minutes_ms =
      minutes
      |> Option.fold
           ~some:(fun minutes -> minutes * Constants.milliseconds_in_minute)
           ~none:0
    in
    let seconds_ms =
      seconds
      |> Option.fold
           ~some:(fun seconds -> seconds * Constants.milliseconds_in_second)
           ~none:0
    in
    years_ms + months_ms + days_ms + hours_ms + minutes_ms + seconds_ms
    + Option.value ~default:0 milliseconds
  ;;

  let to_milliseconds duration = failwith "todo"
  let equal ~comparison duration = failwith "todo"
  let gt ~comparison duration = failwith "todo"
  let gte ~comparison duration = failwith "todo"
  let lt ~comparison duration = failwith "todo"
  let lte ~comparison duration = failwith "todo"
  let add ~amount duration = failwith "todo"
  let subtract ~amount duration = failwith "todo"
end
