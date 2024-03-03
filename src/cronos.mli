(*
    cronos.ml
    A simple and friendly date-time library
    ~~~ wip ~~~
*)

type date
type format
type error

module Duration : sig
  type t

  val make :
    ?milliseconds:int ->
    ?seconds:int ->
    ?minutes:int ->
    ?hours:int ->
    ?days:int ->
    ?weeks:int ->
    ?months:int ->
    ?years:int ->
    unit ->
    t

  val of_milliseconds : int -> t
  val to_milliseconds : t -> int
  val equal : comparison:t -> t -> bool
  val gt : comparison:t -> t -> bool
  val gte : comparison:t -> t -> bool
  val lt : comparison:t -> t -> bool
  val lte : comparison:t -> t -> bool
  val add : amount:t -> t -> t
  val subtract : amount:t -> t -> (t, error) result

  (* accesors *)
  val milliseconds : t -> int
  val seconds : t -> int
  val days : t -> int
  val hours : t -> int
  val minutes : t -> int
  val months : t -> int
  val years : t -> int
end

module Interval : sig
  (* opaque  *)
  type t

  val start : t -> date
  val end' : t -> date
  val are_overlapping : comparison:t -> t -> bool
  val each_millisecond : t -> date list
  val each_second : t -> date list
  val each_minute : t -> date list
  val each_hour : t -> date list
  val each_day : t -> date list
  val each_week : t -> date list
  val each_month : t -> date list
  val each_year : t -> date list
  val milliseconds : t -> int
  val seconds : t -> int
  val minutes : t -> int
  val hours : t -> int
  val days : t -> int
  val weeks : t -> int
  val months : t -> int
  val years : t -> int
end

(* Common helpers *)
val equal : date -> date -> bool
val compare : date -> date -> int
val add : duration:Duration.t -> date -> date
val sub : duration:Duration.t -> date -> date
val closest : dates:date list -> date -> date
val clamp : interval:Interval.t -> date -> date
val is_after : comparison:date -> date -> int
val is_before : comparison:date -> date -> int
val is_future : date -> bool
val is_past : date -> bool
val is_within : interval:Interval.t -> date -> bool
val max : date -> date -> date
val min : date -> date -> date
val to_iso_string : date -> string
val of_string : ?format:format -> string -> (date, error) result
val to_unix : date -> int
val of_unix : int -> date

val to_unix_duration :
  date -> Duration.t (* will return a duration with only seconds *)

val of_unix_duration :
  Duration.t -> date (* will only consider the seconds field *)

(* Conversions *)
val days_to_weeks : int -> int
val hours_to_milliseconds : int -> int
val hours_to_minutes : int -> int
val hours_to_seconds : int -> int
val milliseconds_to_hours : int -> int
val milliseconds_to_minutes : int -> int
val milliseconds_to_seconds : int -> int
val minutes_to_hours : int -> int
val minutes_to_milliseconds : int -> int
val minutes_to_seconds : int -> int
val months_to_years : int -> int
val seconds_to_hours : int -> int
val seconds_to_milliseconds : int -> int
val seconds_to_minutes : int -> int
val weeks_to_days : int -> int
val years_to_days : int -> int
val years_to_months : int -> int

(* Millisecond helpers *)

val add_milliseconds : amount:int -> date -> date
val sub_milliseconds : amoung:int -> date -> date
val difference_in_milliseconds : date -> date -> int
val milliseconds : date -> int
val set_milliseconds : amount:int -> date -> date
val is_same_millisecond : date -> date -> bool
val start_of_millisecond : date -> date
val end_of_millisecond : date -> date

(* Second helpers *)

val add_seconds : amount:int -> date -> date
val sub_seconds : amoung:int -> date -> date
val difference_in_seconds : date -> date -> int
val seconds : date -> int
val set_seconds : amount:int -> date -> date
val is_same_second : date -> date -> bool
val start_of_second : date -> date
val end_of_second : date -> date
