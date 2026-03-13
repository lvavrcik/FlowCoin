export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      activities: {
        Row: {
          created_at: string | null
          default_coins: number
          icon: string | null
          id: string
          name: string
        }
        Insert: {
          created_at?: string | null
          default_coins: number
          icon?: string | null
          id?: string
          name: string
        }
        Update: {
          created_at?: string | null
          default_coins?: number
          icon?: string | null
          id?: string
          name?: string
        }
        Relationships: []
      }
      course_coaches: {
        Row: {
          coach_id: string
          course_id: string
          created_at: string | null
          id: string
        }
        Insert: {
          coach_id: string
          course_id: string
          created_at?: string | null
          id?: string
        }
        Update: {
          coach_id?: string
          course_id?: string
          created_at?: string | null
          id?: string
        }
        Relationships: [
          {
            foreignKeyName: "course_coaches_coach_id_fkey"
            columns: ["coach_id"]
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "course_coaches_course_id_fkey"
            columns: ["course_id"]
            referencedRelation: "courses"
            referencedColumns: ["id"]
          }
        ]
      }
      courses: {
        Row: {
          created_at: string | null
          id: string
          name: string
          season_id: string
        }
        Insert: {
          created_at?: string | null
          id?: string
          name: string
          season_id: string
        }
        Update: {
          created_at?: string | null
          id?: string
          name?: string
          season_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "courses_season_id_fkey"
            columns: ["season_id"]
            referencedRelation: "seasons"
            referencedColumns: ["id"]
          }
        ]
      }
      enrollments: {
        Row: {
          course_id: string
          created_at: string | null
          id: string
          kid_id: string
        }
        Insert: {
          course_id: string
          created_at?: string | null
          id?: string
          kid_id: string
        }
        Update: {
          course_id?: string
          created_at?: string | null
          id?: string
          kid_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "enrollments_course_id_fkey"
            columns: ["course_id"]
            referencedRelation: "courses"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "enrollments_kid_id_fkey"
            columns: ["kid_id"]
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          }
        ]
      }
      merch_items: {
        Row: {
          cost: number
          created_at: string | null
          id: string
          image_url: string | null
          name: string
          stock: number | null
        }
        Insert: {
          cost: number
          created_at?: string | null
          id?: string
          image_url?: string | null
          name: string
          stock?: number | null
        }
        Update: {
          cost?: number
          created_at?: string | null
          id?: string
          image_url?: string | null
          name?: string
          stock?: number | null
        }
        Relationships: []
      }
      profiles: {
        Row: {
          created_at: string | null
          first_name: string
          flowcoins_balance: number | null
          id: string
          last_name: string
          pin_code: string | null
          role: string
          user_id: string | null
        }
        Insert: {
          created_at?: string | null
          first_name: string
          flowcoins_balance?: number | null
          id?: string
          last_name: string
          pin_code?: string | null
          role: string
          user_id?: string | null
        }
        Update: {
          created_at?: string | null
          first_name?: string
          flowcoins_balance?: number | null
          id?: string
          last_name?: string
          pin_code?: string | null
          role?: string
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "profiles_user_id_fkey"
            columns: ["user_id"]
            referencedRelation: "users"
            referencedColumns: ["id"]
          }
        ]
      }
      purchases: {
        Row: {
          created_at: string | null
          id: string
          kid_id: string
          merch_item_id: string
          status: string
        }
        Insert: {
          created_at?: string | null
          id?: string
          kid_id: string
          merch_item_id: string
          status?: string
        }
        Update: {
          created_at?: string | null
          id?: string
          kid_id?: string
          merch_item_id?: string
          status?: string
        }
        Relationships: [
          {
            foreignKeyName: "purchases_kid_id_fkey"
            columns: ["kid_id"]
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "purchases_merch_item_id_fkey"
            columns: ["merch_item_id"]
            referencedRelation: "merch_items"
            referencedColumns: ["id"]
          }
        ]
      }
      seasons: {
        Row: {
          created_at: string | null
          id: string
          is_active: boolean | null
          name: string
        }
        Insert: {
          created_at?: string | null
          id?: string
          is_active?: boolean | null
          name: string
        }
        Update: {
          created_at?: string | null
          id?: string
          is_active?: boolean | null
          name?: string
        }
        Relationships: []
      }
      transactions: {
        Row: {
          activity_id: string | null
          amount: number
          coach_id: string
          created_at: string | null
          custom_reason: string | null
          id: string
          kid_id: string
        }
        Insert: {
          activity_id?: string | null
          amount: number
          coach_id: string
          created_at?: string | null
          custom_reason?: string | null
          id?: string
          kid_id: string
        }
        Update: {
          activity_id?: string | null
          amount?: number
          coach_id?: string
          created_at?: string | null
          custom_reason?: string | null
          id?: string
          kid_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "transactions_activity_id_fkey"
            columns: ["activity_id"]
            referencedRelation: "activities"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "transactions_coach_id_fkey"
            columns: ["coach_id"]
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "transactions_kid_id_fkey"
            columns: ["kid_id"]
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          }
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}
