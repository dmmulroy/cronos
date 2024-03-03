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
type error = Invalid_date | Negative_duration

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
      Float.of_int milliseconds /. Float.of_int Constants.milliseconds_in_year
      |> Float.floor |> Float.to_int
    in
    let milliseconds =
      milliseconds - (Constants.milliseconds_in_year * years)
    in

    let months =
      Float.of_int milliseconds /. Float.of_int Constants.milliseconds_in_month
      |> Float.floor |> Float.to_int
    in
    let milliseconds =
      milliseconds - (Constants.milliseconds_in_month * months)
    in

    let days =
      Float.of_int milliseconds /. Float.of_int Constants.milliseconds_in_day
      |> Float.floor |> Float.to_int
    in
    let milliseconds = milliseconds - (Constants.milliseconds_in_day * days) in

    let hours =
      Float.of_int milliseconds /. Float.of_int Constants.milliseconds_in_hour
      |> Float.floor |> Float.to_int
    in
    let milliseconds =
      milliseconds - (Constants.milliseconds_in_hour * hours)
    in

    let hours =
      Float.of_int milliseconds /. Float.of_int Constants.milliseconds_in_hour
      |> Float.floor |> Float.to_int
    in
    let milliseconds =
      milliseconds - (Constants.milliseconds_in_hour * hours)
    in

    let minutes =
      Float.of_int milliseconds /. Float.of_int Constants.milliseconds_in_minute
      |> Float.floor |> Float.to_int
    in
    let milliseconds =
      milliseconds - (Constants.milliseconds_in_minute * minutes)
    in

    let seconds =
      Float.of_int milliseconds /. Float.of_int Constants.milliseconds_in_second
      |> Float.floor |> Float.to_int
    in
    let milliseconds =
      milliseconds - (Constants.milliseconds_in_second * seconds)
    in

    make ~years ~months ~days ~hours ~minutes ~seconds ~milliseconds ()
  ;;

  let to_milliseconds
      { years; months; days; hours; minutes; seconds; milliseconds } =
    let years_milliseconds =
      Option.fold years ~some:(Int.mul Constants.milliseconds_in_year) ~none:0
    in
    let months_milliseconds =
      Option.fold months ~some:(Int.mul Constants.milliseconds_in_month) ~none:0
    in
    let days_milliseconds =
      Option.fold days ~some:(Int.mul Constants.milliseconds_in_day) ~none:0
    in
    let hours_milliseconds =
      Option.fold hours ~some:(Int.mul Constants.milliseconds_in_hour) ~none:0
    in
    let minutes_milliseconds =
      Option.fold minutes
        ~some:(Int.mul Constants.milliseconds_in_minute)
        ~none:0
    in
    let seconds_milliseconds =
      Option.fold seconds
        ~some:(Int.mul Constants.milliseconds_in_second)
        ~none:0
    in
    years_milliseconds + months_milliseconds + days_milliseconds
    + hours_milliseconds + minutes_milliseconds + seconds_milliseconds
    + Option.value ~default:0 milliseconds
  ;;

  let equal ~comparison duration = comparison = duration

  let gt ~comparison duration =
    to_milliseconds duration > to_milliseconds comparison
  ;;

  let gte ~comparison duration =
    to_milliseconds duration >= to_milliseconds comparison
  ;;

  let lt ~comparison duration =
    to_milliseconds duration < to_milliseconds comparison
  ;;

  let lte ~comparison duration =
    to_milliseconds duration <= to_milliseconds comparison
  ;;

  let add ~amount duration =
    of_milliseconds (to_milliseconds amount + to_milliseconds duration)
  ;;

  let subtract ~amount duration =
    let result_milliseconds =
      to_milliseconds amount - to_milliseconds duration
    in
    let result = of_milliseconds result_milliseconds in
    match result_milliseconds >= 0 with
    | true -> Ok result
    | false -> Error Negative_duration
  ;;
end

module Interval = struct
  type t = { start : date; end' : date }

  let make ~start ~end' = { start; end' }
  let start interval = interval.start
  let end' interval = interval.end'
  let are_overlapping ~comparison interval = failwith "todo"
end
